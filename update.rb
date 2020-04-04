#!/usr/bin/env ruby

require 'open-uri'
require 'opengraph_parser'
require 'octokit'
require 'yaml'

def update_profile
  print 'Updating profile picture...'
  File.open("./assets/images/profile.jpg", "wb") do |file|
    file.write open('https://github.com/espositoandrea.png').read
  end
  puts ' Done'
  $stdout.flush
end

def hash_from_repo(repo)
  repo_metadata = OpenGraph.new(repo.html_url)
  languages_metadata = Octokit.languages(repo.id)
  languages = Hash[languages_metadata.to_hash.map{ |k, v| [k.to_s, v] }]

  website = !repo.homepage.nil? ? repo.homepage : (repo.has_pages ? "https://#{repo.owner.login}.github.io/#{repo.name}" : nil)

  {
      'name' => repo.name,
      'fork' => repo.fork,
      'html_url' => repo.html_url,
      'homepage' => website,
      'has_website' => !website.nil?,
      'image' => repo_metadata.images[0],
      'description' => repo.description,
      'language' => repo.language,
      'languages' => languages.to_a.sort_by(&:last).reverse.to_h.keys # Force languages to be ordered from most to less used
  }
end

USERNAME = 'espositoandrea'

def update_repositories
  repos = Octokit.repositories(USERNAME)

  data = []
  repos.each do |repo|
    puts "[ #{repo.owner.login} / #{repo.name} ]"
    data.push(hash_from_repo(repo))
  end

  to_save = {USERNAME => data, 'orgs' => {} }

  orgs = Octokit.organizations(USERNAME)
  data = []
  orgs.each do |org|
    repos = Octokit.repositories(org.login)

    data = []
    repos.each do |repo|
      next if repo.name.match(/.*?\.github\.io/)

      puts "[ #{org.login} / #{repo.name} ]"
      data.push(hash_from_repo(repo))
    end
    to_save['orgs'].merge!(org.login => data)
  end

  File.open('_data/repos_data.yml', 'w') { |file| file.write(to_save.to_yaml) }
end

update_profile
update_repositories
