# typed: true
# frozen_string_literal: true

require "abstract_command"

module Homebrew
  module Cmd
    class CheckCiStatusCmd < AbstractCommand
      cmd_args do
        description <<~EOS
          Check the status of CI tests. Used to determine whether tests can be
          cancelled, or whether a long-timeout label can be removed.
        EOS

        switch "--cancel", description: "Determine whether tests can be cancelled."
        switch "--long-timeout-label", description: "Determine whether a long-timeout label can be removed."

        named_args :pull_request_number, number: 1

        hide_from_man_page!
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
                          databaseId
                          createdAt
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

      def get_workflow_run_status(pull_request)
        @status_cache ||= {}
        return @status_cache[pull_request] if @status_cache.include? pull_request

        owner, name = ENV.fetch("GITHUB_REPOSITORY").split("/")
        variables = {
          owner:,
          name:,
          pr:    pull_request,
        }
        odebug "Checking CI status for #{owner}/#{name}##{pull_request}..."

        response = GitHub::API.open_graphql(GRAPHQL_WORKFLOW_RUN_QUERY, variables:, scopes: ["repo"].freeze)
        commit_node = response.dig("repository", "pullRequest", "commits", "nodes", 0)
        check_suite_nodes = commit_node.dig("commit", "checkSuites", "nodes")
        ci_nodes = check_suite_nodes.select do |node|
          workflow_run = node.fetch("workflowRun")
          next false if workflow_run.blank?

          workflow_run.fetch("event") == "pull_request" && workflow_run.dig("workflow", "name") == "CI"
        end
        # There can be multiple CI nodes when a PR is closed and reopened.
        # Make sure we use the latest one in this case.
        ci_node = ci_nodes.max_by { |node| DateTime.parse(node.dig("workflowRun", "createdAt")) }
        return [nil, nil] if ci_node.blank?

        check_run_nodes = ci_node.dig("checkRuns", "nodes")

        @status_cache[pull_request] = [ci_node, check_run_nodes]
        [ci_node, check_run_nodes]
      end

      def run_id_if_cancellable(pull_request)
        ci_node, = get_workflow_run_status(pull_request)
        return if ci_node.nil?

        # Possible values: COMPLETED, IN_PROGRESS, PENDING, QUEUED, REQUESTED, WAITING
        # https://docs.github.com/en/graphql/reference/enums#checkstatusstateb
        ci_status = ci_node.fetch("status")
        odebug "CI status: #{ci_status}"
        return if ci_status == "COMPLETED"

        ci_run_id = ci_node.dig("workflowRun", "databaseId")
        odebug "CI run ID: #{ci_run_id}"
        ci_run_id
      end

      def allow_long_timeout_label_removal?(pull_request)
        ci_node, check_run_nodes = get_workflow_run_status(pull_request)
        return false if ci_node.nil?

        ci_status = ci_node.fetch("status")
        odebug "CI status: #{ci_status}"
        return true if ci_status == "COMPLETED"

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

      def run
        pr = args.named.first.to_i

        if !args.cancel? && !args.long_timeout_label?
          raise UsageError, "At least one of `--cancel` and `--long-timeout-label` is needed."
        end

        outputs = {}

        if args.cancel?
          run_id = run_id_if_cancellable(pr)
          outputs["cancellable-run-id"] = run_id.to_json
        end

        if args.long_timeout_label?
          allow_removal = allow_long_timeout_label_removal?(pr)
          outputs["allow-long-timeout-label-removal"] = allow_removal
        end

        github_output = ENV.fetch("GITHUB_OUTPUT")
        File.open(github_output, "a") do |f|
          outputs.each do |key, value|
            odebug "#{key}: #{value}"
            f.puts "#{key}=#{value}"
          end
        end
      end
    end
  end
end
