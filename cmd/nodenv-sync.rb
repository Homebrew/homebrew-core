# frozen_string_literal: true

require "cli/parser"
require "formula"

module Homebrew
  module_function

  def nodenv_sync_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `nodenv-sync`

        Create symlinks for Homebrew's installed NodeJS versions in ~/.nodenv/versions.

        Note that older version symlinks will also be created so e.g. NodeJS 19.1.0 will
        also be symlinked to 19.0.0.
      EOS

      named_args :none
    end
  end

  def nodenv_sync
    dot_nodenv = Pathname(Dir.home)/".nodenv"

    # Don't run multiple times at once.
    nodenv_sync_running = dot_nodenv/".nodenv_sync_running"
    return if nodenv_sync_running.exist?

    @nodenv_versions = dot_nodenv/"versions"
    @nodenv_versions.mkpath
    FileUtils.touch nodenv_sync_running

    nodenv_sync_args.parse

    HOMEBREW_CELLAR.glob("node{,@*}")
                   .flat_map(&:children)
                   .sort_by(&method(:gem_like_version))
                   .each(&method(:link_nodenv_versions))

    @nodenv_versions.children
                    .select(&:symlink?)
                    .reject(&:exist?)
                    .each { |path| FileUtils.rm_f path }
  ensure
    nodenv_sync_running.unlink if nodenv_sync_running.exist?
  end

  def gem_like_version(version_path)
    Gem::Version.new(version_path.basename
                                 .to_s
                                 .tr("_", "."))
  end

  def gem_version_segments(version_path)
    basename_without_revision = version_path.basename
                                            .to_s
                                            .gsub(/_\d+$/, "")
    Gem::Version.new(basename_without_revision)
                .canonical_segments
  end

  def link_version(version_path, version_name, versions_path)
    link_path = versions_path / version_name

    FileUtils.rm_f link_path
    FileUtils.ln_sf version_path, link_path
  end

  def link_nodenv_versions(version_path)
    @nodenv_versions.mkpath

    major_version, minor_version, patch_version = gem_version_segments(version_path)
    minor_version ||= 0
    (0..minor_version).each do |minor|
      patch_version ||= 0
      (0..patch_version).each do |patch|
        link_version(version_path, "#{major_version}.#{minor}.#{patch}", @nodenv_versions)
      end
    end
  end
end
