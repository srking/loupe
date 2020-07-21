require 'octokit'
require 'thor'
require 'yaml'

module Loupe
  class CLI < Thor
    TYPE = 'gem'.freeze
    BUNDLE_OUTDATED_FORMAT = /^(?<name>[A-Za-z0-9_-]+) \(newest (?<to_version>[0-9a-z.]+), installed (?<from_version>[0-9a-z.]+)\)$/
    
    desc 'inspect', 'Inspect for and log outdated dependencies'
    def inspect
      client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
      bundle_outdated_results = `bundle outdated --patch --porcelain --only-explicit`
      dependencies = bundle_outdated_results.split("\n").select { |r| r.match?(BUNDLE_OUTDATED_FORMAT) }.map do |result|
        result.match(BUNDLE_OUTDATED_FORMAT) { |m| Dependency.new(m.named_captures.merge(type: TYPE)) }
      end
      tickets = client.issues(ENV['GITHUB_REPO'], query: { state: :all, labels: 'loupe' }).map do |issue|
        Loupe::Dependency.new(YAML.load(issue.body))
      end
      dependencies.each do |dependency|
        next if tickets.any? do |ticket|
          dependency.type == ticket.type && dependency.name == ticket.name && dependency.from_version == ticket.from_version
        end
        title = "Update #{dependency.name} to v#{dependency.to_version}"
        body = YAML.dump(dependency.to_h)
        client.create_issue(ENV['GITHUB_REPO'], title, body, { labels: 'loupe' })
      end
    end
  end
end
