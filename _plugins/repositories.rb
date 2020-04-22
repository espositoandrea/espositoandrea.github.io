# frozen_string_literals: true

require 'octokit'
require 'nokogiri'
require 'faraday-http-cache'
require 'ogp'

module Jekyll
  class RepositoriesTag < Liquid::Tag
    def initialize(tag_name, repositories, tokens)
      super
      @repositories = repositories
    end

    def render(context)
      @repositories = context[@repositories.strip]
      username = "#{context['site.github_username']}"

      stack = Faraday::RackBuilder.new do |builder|
        builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
        builder.use Octokit::Response::RaiseError
        builder.adapter Faraday.default_adapter
      end
      Octokit.middleware = stack

      client = Octokit::Client.new access_token: ENV['JEKYLL_GITHUB_TOKEN']
      repositories = {
          'me': client.repositories(username),
          'organizations': @repositories['organizations'].keys.map { |org| [org, client.repositories(org)] }.to_h
      }

      result = '<div class="card-columns">'
      repositories[:me].each { |repo| result += get_card(repo).to_html if @repositories['me'].include? repo.name }
      repositories[:organizations].each do |org, repos|
        repos.each { |repo| result += get_card(repo, org).to_html if @repositories['organizations'][org].include? repo.name }
      end
      result + '</div>'
    end

    def get_card(repository, organization = nil)
      repo_metadata = OGP::OpenGraph.new(Faraday.get(repository.html_url).body)
      website = if !repository.homepage.nil?
                  repository.homepage
                else
                  repository.has_pages ? "https://#{repository.owner.login}.github.io/#{repository.name}" : nil
                end

      builder = Nokogiri::HTML::Builder.new do |doc|
        doc.div(class: 'card') {
          unless organization.nil?
            doc.div(class: "card-header text-muted") {
              doc.text "#{organization} "
              doc.em { doc.text '(Organization)' }
            }
          end
          doc.img(src: repo_metadata.image.url, class: "card-img-top", alt: repository.name.gsub('-', ' '))
          doc.div(class: 'card-body') {
            doc.h5(class: "card-title") {
              doc.text repository.name.gsub("-", " ")
              if repository.fork
                doc.small(class: "badge badge-pill badge-info") {
                  doc.em { doc.text 'fork' }
                }
              end
            }
            doc.p(class: "card-text") { doc.text repository.description }
            doc.p(class: "card-text") {
              Octokit.languages(repository.id).to_a.sort_by(&:last).reverse.to_h.keys.each_with_index do |language, i|
                doc.span(class: "badge badge-pill #{(i == 0) ? 'badge-info' : 'badge-secondary'}") {
                  doc.text language
                }
              end
            }
          }
          doc.div(class: 'card-footer text-center') {
            doc.div('aria-label': 'Links', class: 'btn-group d-flex', role: 'group') {
              doc.a(href: repository.html_url, target: '_blank', class: 'btn btn-primary') {
                doc.text 'Repo'
              }

              unless website.nil?
                doc.a(href: website, target: '_blank', class: 'btn btn-secondary') {
                  doc.text 'Website'
                }
              end
            }
          }
        }
      end

      Nokogiri::HTML::DocumentFragment.parse builder.to_html
    end

    Liquid::Template.register_tag 'repositories', self
  end
end

