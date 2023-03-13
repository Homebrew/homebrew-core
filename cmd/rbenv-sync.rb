# frozen_string_literal: true

require "cli/parser"
require "formula"

module Homebrew
  module_function

  def rbenv_sync_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `rbenv-sync`

        Create symlinks for Homebrew's installed Ruby versions in ~/.rbenv/versions.

        Note that older version symlinks will also be created so e.g. Ruby 3.2.1 will
        also be symlinked to 3.2.0.
      EOS

      named_args :none
    end
  end

  def rbenv_sync
    dot_rbenv = Pathname(Dir.home)/".rbenv"

    # Don't run multiple times at once.
    rbenv_sync_running = dot_rbenv/".rbenv_sync_running"
    return if rbenv_sync_running.exist?

    @rbenv_versions = dot_rbenv/"versions"
    @rbenv_versions.mkpath
    FileUtils.touch rbenv_sync_running

    rbenv_sync_args.parse

    HOMEBREW_CELLAR.glob("ruby{,@*}")
                   .flat_map(&:children)
                   .sort_by(&method(:gem_like_version))
                   .each(&method(:link_rbenv_versions))

    @rbenv_versions.children
                   .select(&:symlink?)
                   .reject(&:exist?)
                   .each { |path| FileUtils.rm_f path }
  ensure
    rbenv_sync_running.unlink if rbenv_sync_running.exist?
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
    link_path = versions_path/version_name

    FileUtils.rm_f link_path
    FileUtils.ln_sf version_path, link_path
  end

  def link_rbenv_versions(version_path)
    major_version, minor_version, patch_version = gem_version_segments(version_path)
    patch_version ||= 0
    (0..patch_version).each do |patch|
      link_version(version_path, "#{major_version}.#{minor_version}.#{patch}", @rbenv_versions)
    end
  end
end
