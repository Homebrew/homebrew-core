# typed: strict
# frozen_string_literal: true

require "abstract_command"
require "formula"

module Homebrew
  module Cmd
    class DetermineRebottleRunnersCmd < AbstractCommand
      cmd_args do
        usage_banner <<~EOS
          `determine-rebottle-runners` <formula> <timeout>

          Determines the runners to use to rebottle a formula.
        EOS

        named_args number: 2

        hide_from_man_page!
      end

      sig { params(arch: Symbol, timeout: Integer).returns(T::Hash[Symbol, T.any(String, T::Hash[Symbol, String])]) }
      def linux_runner_spec(arch, timeout)
        linux_runner = if arch == :arm64
          "ubuntu-22.04-arm"
        elsif timeout > 360
          "linux-self-hosted-1"
        else
          "ubuntu-latest"
        end

        {
          runner:    linux_runner,
          container: {
            image:   "ghcr.io/homebrew/ubuntu22.04:main",
            options: "--user=linuxbrew -e GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED",
          },
          workdir:   "/github/home",
        }
      end

      KNOWN_LINUX_ARCHES = [:arm64, :x86_64].freeze

      sig { override.void }
      def run
        formula = Formula[T.must(args.named.first)]
        timeout = args.named.second.to_i

        tags = formula.bottle_specification.collector.tags
        runners = if tags.one? && tags.first.system == :all
          # Build on all supported macOS versions and Linux.
          [linux_runner_spec(:x86_64, timeout)] + MacOSVersion::SYMBOLS.keys.flat_map do |symbol|
            macos_version = MacOSVersion.from_symbol(symbol)
            if macos_version.outdated_release? || macos_version.prerelease?
              nil
            else
              ephemeral_suffix = "-#{ENV.fetch("GITHUB_RUN_ID")}-dispatch"
              macos_runners = [{ runner: "#{macos_version}-x86_64#{ephemeral_suffix}" }]
              macos_runners << { runner: "#{macos_version}-arm64#{ephemeral_suffix}" }
              macos_runners
            end
          end
        else
          tags.map do |tag|
            macos_version = tag.to_macos_version

            if macos_version.outdated_release?
              nil # Don't rebottle for older macOS versions (no CI to build them).
            else
              runner = macos_version.to_s
              runner += "-#{tag.arch}"
              runner += "-#{ENV.fetch("GITHUB_RUN_ID")}"
              runner += "-dispatch"

              { runner: }
            end
          rescue MacOSVersion::Error
            if tag.system == :linux && KNOWN_LINUX_ARCHES.include?(tag.arch)
              linux_runner_spec(tag.arch, timeout)
            elsif tag.system == :all
              # An all bottle with OS-specific bottles also present - ignore it.
              nil
            else
              raise "Unknown tag: #{tag}"
            end
          end
        end.compact

        github_output = ENV.fetch("GITHUB_OUTPUT") { raise "GITHUB_OUTPUT is not defined" }
        File.open(github_output, "a") do |f|
          f.puts("runners=#{runners.to_json}")
        end
      end
    end
  end
end
