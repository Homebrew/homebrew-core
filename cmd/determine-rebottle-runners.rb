# frozen_string_literal: true

require "cli/parser"
require "formula"

module Homebrew
  module_function

  def determine_rebottle_runners_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `determine-rebottle-runners` <formula> <timeout>

        Determines the runners to use to rebottle a formula.
      EOS

      named_args number: 2

      hide_from_man_page!
    end
  end

  def determine_rebottle_runners
    args = determine_rebottle_runners_args.parse

    formula = Formula[args.named.first]
    timeout = args.named.second.to_i

    linux_runner = if timeout > 360
      "linux-self-hosted-1"
    else
      "ubuntu-22.04"
    end
    linux_runner_spec = {
      runner:    linux_runner,
      container: {
        image:   "ghcr.io/homebrew/ubuntu22.04:master",
        options: "--user=linuxbrew -e GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED",
      },
      workdir:   "/github/home",
    }

    tags = formula.bottle_specification.collector.tags
    runners = if tags.count == 1 && tags.first.system == :all
      # Build on all supported macOS versions and Linux.
      MacOSVersions::SYMBOLS.values.flat_map do |version|
        macos_version = MacOS::Version.new(version)
        if macos_version.outdated_release? || macos_version.prerelease?
          nil
        else
          ephemeral_suffix = "-#{ENV.fetch("GITHUB_RUN_ID")}-#{ENV.fetch("GITHUB_RUN_ATTEMPT")}"
          macos_runners = [{ runner: "#{macos_version}#{ephemeral_suffix}" }]
          if macos_version >= :ventura
            macos_runners << { runner: "#{macos_version}-arm64#{ephemeral_suffix}" }
          elsif macos_version >= :big_sur
            macos_runners << { runner: "#{macos_version}-arm64" }
          end
          macos_runners
        end
      end << linux_runner_spec
    else
      tags.map do |tag|
        macos_version = tag.to_macos_version

        if macos_version.outdated_release?
          nil # Don't rebottle for older macOS versions (no CI to build them).
        else
          runner = macos_version.to_s
          runner += "-#{tag.arch}" if tag.arch != :x86_64
          if tag.arch == :x86_64 || macos_version >= :ventura
            runner += "-#{ENV.fetch("GITHUB_RUN_ID")}-#{ENV.fetch("GITHUB_RUN_ATTEMPT")}"
          end
          { runner: runner }
        end
      rescue MacOSVersionError
        if tag.system == :linux && tag.arch == :x86_64
          linux_runner_spec
        elsif tag.system == :all
          # An all bottle with OS-specific bottles also present - ignore it.
          nil
        else
          raise "Unknown tag: #{tag}"
        end
      end
    end.compact

    puts "::set-output name=runners::#{runners.to_json}"
  end
end
