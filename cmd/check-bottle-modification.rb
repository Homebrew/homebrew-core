# typed: true
# frozen_string_literal: true

require "abstract_command"

module Homebrew
  module Cmd
    class CheckBottleModificationCmd < AbstractCommand
      cmd_args do
        description <<~EOS
          Check that the bottle block of a formula is modified only by BrewTestBot.
        EOS

        named_args :pull_request_number, number: 1

        hide_from_man_page!
      end

      UNCHECKED_COMMIT_AUTHORS = ["BrewTestBot"].freeze
      MODIFIED_BOTTLE_BLOCK_REGEX = /^(\+|-)\s*(bottle do|sha256.*:\s+"\h{64}")/

      def get_pull_request_commits(pull_request)
        owner, repo = ENV.fetch("GITHUB_REPOSITORY").split("/")
        response = GitHub::API.open_rest(GitHub.url_to("repos", owner, repo, "pulls", pull_request, "commits"))

        response.reject! do |item|
          item.fetch("parents").count > 1 ||
            UNCHECKED_COMMIT_AUTHORS.include?(item.dig("commit", "author", "name")) ||
            UNCHECKED_COMMIT_AUTHORS.include?(item.dig("commit", "committer", "name"))
        end

        response.map { |item| item.fetch("sha") }
      end

      def commit_modifies_bottle_block?(sha)
        owner, repo = ENV.fetch("GITHUB_REPOSITORY").split("/")
        response = GitHub::API.open_rest(GitHub.url_to("repos", owner, repo, "commits", sha))

        files = response.fetch("files")
        files.reject! do |file|
          next true if %w[renamed removed].include?(file.fetch("status"))

          filename = file.fetch("filename")
          !filename.start_with?("Formula/") || !filename.end_with?(".rb")
        end

        files.any? { |file| patch_modifies_bottle_block?(file.fetch("patch")) }
      end

      def patch_modifies_bottle_block?(patch)
        patch.lines.any? { |line| line.match?(MODIFIED_BOTTLE_BLOCK_REGEX) }
      end

      def run
        pr = args.named.first.to_i
        commits = get_pull_request_commits(pr)

        odie "PR##{pr} modifies the bottle block" if commits.any? { |sha| commit_modifies_bottle_block?(sha) }
      end
    end
  end
end
