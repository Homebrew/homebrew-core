# frozen_string_literal: true

require "cli/parser"

module Homebrew
  def self.check_ci_status_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `check-ci-status` <pull-request-number>

        Check the status of CI tests. Used to determine whether a long-timeout label can be removed.
      EOS

      named_args number: 1

      hide_from_man_page!
    end
  end

  GRAPHQL_WORKFLOW_RUN_QUERY = <<~GRAPHQL
    query ($owner: String!, $name: String!, $pr: Int!) {
      repository(owner: $owner, name: $name) {
        pullRequest(number: $pr) {
          commits(last: 1) {
            nodes {
              commit {
                checkSuites(last: 100) {
                  nodes {
                    status
                    workflowRun {
                      event
                      workflow {
                        name
                      }
                    }
                    checkRuns(last: 100) {
                      nodes {
                        name
                        status
                        conclusion
                        databaseId
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  GRAPHQL
  ALLOWABLE_REMAINING_MACOS_RUNNERS = 1

  def self.allow_long_timeout_label_removal?(pull_request)
    owner, name = ENV.fetch("GITHUB_REPOSITORY").split("/")
    variables = {
      owner: owner,
      name:  name,
      pr:    pull_request,
    }
    odebug "Checking CI status for #{owner}/#{name}##{pull_request}..."

    response = GitHub::API.open_graphql(GRAPHQL_WORKFLOW_RUN_QUERY, variables: variables, scopes: ["repo"].freeze)
    commit_node = response.dig("repository", "pullRequest", "commits", "nodes", 0)
    check_suite_nodes = commit_node.dig("commit", "checkSuites", "nodes")
    ci_node = check_suite_nodes.find do |node|
      workflow_run = node.fetch("workflowRun")
      next false if workflow_run.blank?

      workflow_run.fetch("event") == "pull_request" && workflow_run.dig("workflow", "name") == "CI"
    end
    return false if ci_node.blank?

    status = ci_node.fetch("status")
    odebug "CI status: #{status}"
    return true if status == "COMPLETED"

    check_run_nodes = ci_node.dig("checkRuns", "nodes")
    # The `test_deps` job is still waiting to be processed.
    return false if check_run_nodes.none? { |node| node.fetch("name").end_with?("(deps)") }

    incomplete_macos_checks = check_run_nodes.select do |node|
      check_run_status = node.fetch("status")
      check_run_name = node.fetch("name")
      odebug "#{check_run_name}: #{check_run_status}"

      check_run_status != "COMPLETED" && check_run_name.start_with?("macOS")
    end

    incomplete_macos_checks.count <= ALLOWABLE_REMAINING_MACOS_RUNNERS
  end

  def self.check_ci_status
    args = check_ci_status_args.parse
    pr = args.named.first.to_i
    allow_removal = allow_long_timeout_label_removal?(pr)

    github_output = ENV.fetch("GITHUB_OUTPUT")
    File.open(github_output, "a") do |f|
      f.puts("allow-long-timeout-label-removal=#{allow_removal}")
    end
  end
end
