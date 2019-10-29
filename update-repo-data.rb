require 'opengraph_parser'
require 'octokit'
require 'yaml'

def hash_from_repo(repo)
  movie = OpenGraph.new(repo.html_url)
  {
      'name' => repo.name,
      'fork' => repo.fork,
      'html_url' => repo.html_url,
      'has_pages' => repo.has_pages,
      'homepage' => repo.homepage,
      'image' => movie.images[0],
      'description' => repo.description,
  }
end

USERNAME = 'espositoandrea'

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
