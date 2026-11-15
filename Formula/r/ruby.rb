class Ruby < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  license "Ruby"
  compatibility_version 1

  stable do
    # TODO: enable default_user_install when updating to Ruby 4.1
    url "https://cache.ruby-lang.org/pub/ruby/4.0/ruby-4.0.9.tar.gz"
    sha256 "c35350682ff050b79702d57ade4516e7336063f510155d19fb2fb5b3f3909511"

    # Should be updated only when Ruby is updated (if an update is available).
    # The exception is Rubygem security fixes, which mandate updating this
    # formula & the versioned equivalents and bumping the revisions.
    resource "rubygems" do
      url "https://rubygems.org/rubygems/rubygems-4.0.23.tgz"
      sha256 "843f89b1c9c35c28f7ccaf4580cde1e7b00dbd1907b46bcfdcdbc6afa7345e56"

      livecheck do
        url "https://rubygems.org/pages/download"
        regex(/href=.*?rubygems[._-]v?(\d+(?:\.\d+)+)\.t/i)
      end
    end
  end

  livecheck do
    url "https://www.ruby-lang.org/en/downloads/releases/"
    regex(/href=.*?ruby[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e994fdb3c373383034f8a54edde2208e1a96ce9eaa6d1359fc9e612791c1eefd"
    sha256 arm64_tahoe:       "e921e4fc82aff42272e57fe7fb25fc11e4d4dc2bd2ee3a6ac53815303c0f28ce"
    sha256 arm64_sequoia:     "3f37570afbe7c40f8807b79fa16fd280a9fc3c8508066538ab15b0b2be80f05a"
    sha256 arm64_linux:       "82db38cc052c7290d5f16dfc4b59737c14c0080faf3efa9159cdb00d9ca970b3"
    sha256 x86_64_linux:      "ab2f6735d619f1aae4c2f29ca8e25b3a086a4290c169b8ff57de34498498ec6e"
  end

  head do
    url "https://github.com/ruby/ruby.git", branch: "master"

    depends_on "autoconf" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "openssl@4"

  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # TODO: remove when enabling default_user_install
  link_overwrite "bin/bundle", "bin/bundler"

  # Test installs gems from rubygems.org
  allow_network_access! :test

  def determine_api_version
    Utils.safe_popen_read(bin/"ruby", "-e", "print Gem.ruby_api_version")
  end

  def api_version
    if head?
      if latest_head_prefix
        determine_api_version
      else
        # Best effort guess
        "#{stable.version.major.to_i}.#{stable.version.minor.to_i + 1}.0+0"
      end
    else
      "#{version.major.to_i}.#{version.minor.to_i}.0"
    end
  end

  def rubygems_bindir
    HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/bin"
  end

  def versioned_opt_prefix
    opt_prefix.dirname/"ruby@#{version.major_minor}"
  end

  def install
    paths = %w[libyaml openssl@4].map { |f| formula_opt_prefix(f) }
    # Add versioned Ruby RPATH so user-installed gems can work when user is switched to versioned Ruby
    paths << versioned_opt_prefix if OS.linux? && !versioned_formula?

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-silent-rules
      --with-sitedir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}/lib/ruby/vendor_ruby
      --with-opt-dir=#{paths.join(":")}
      --without-gmp
    ]
    args << "--with-baseruby=#{RbConfig.ruby}" if build.head?
    args << "--disable-dtrace" if OS.mac? && !MacOS::CLT.installed?

    # Avoid stdckdint.h on macOS 15 as it's not available in Xcode 16.0-16.2,
    # and if the build system picks it up it'll use it for runtime builds too.
    args << "ac_cv_header_stdckdint_h=no" if OS.mac? && MacOS.version == :sequoia

    # Ruby has been configured to look in the HOMEBREW_PREFIX for the
    # sitedir and vendordir directories; however we don't actually want to create
    # them during the install.
    #
    # These directories are empty on install; sitedir is used for non-rubygems
    # third party libraries, and vendordir is used for packager-provided libraries.
    inreplace "tool/rbinstall.rb" do |s|
      s.gsub! 'prepare "extension scripts", sitelibdir', ""
      s.gsub! 'prepare "extension scripts", vendorlibdir', ""
      s.gsub! 'prepare "extension objects", sitearchlibdir', ""
      s.gsub! 'prepare "extension objects", vendorarchlibdir', ""
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    # A newer version of ruby-mode.el is shipped with Emacs
    elisp.install Dir["misc/*.el"].reject { |f| f == "misc/ruby-mode.el" }

    if build.stable? # Use bundled RubyGems for --HEAD (will be newer)
      # This is easier than trying to keep both current & versioned Ruby
      # formulae repeatedly updated with Rubygem patches.
      resource("rubygems").stage do
        ENV.prepend_path "PATH", bin

        system bin/"ruby", "setup.rb", "--prefix=#{buildpath}/vendor_gem"
        rg_in = lib/"ruby/#{api_version}"
        rg_gems_in = lib/"ruby/gems/#{api_version}"

        # Remove bundled Rubygem and Bundler
        rm_r rg_in/"bundler"
        rm rg_in/"bundler.rb"
        rm_r Dir[rg_gems_in/"gems/bundler-*"]
        rm Dir[rg_gems_in/"specifications/default/bundler-*.gemspec"]
        rm_r rg_in/"rubygems"
        rm rg_in/"rubygems.rb"
        rm bin/"gem"

        # Drop in the new version.
        rg_in.install Dir[buildpath/"vendor_gem/lib/*"]
        (rg_gems_in/"gems").install Dir[buildpath/"vendor_gem/gems/*"]
        (rg_gems_in/"specifications/default").install Dir[buildpath/"vendor_gem/specifications/default/*"]
        bin.install buildpath/"vendor_gem/bin/gem" => "gem"
        bin.install buildpath/"vendor_gem/bin/bundle" => "bundle"
        bin.install buildpath/"vendor_gem/bin/bundler" => "bundler"
      end
    end

    # Customize rubygems to look/install in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib/"ruby/#{api_version}/rubygems/defaults/operating_system.rb"
    config_file.write rubygems_config
  end

  # Since Gem ships Bundle we want to provide that full/expected installation
  # but to do so we need to handle the case where someone has previously
  # installed bundle manually via `gem install`.
  # TODO: remove the `remove` step when enabling default_user_install
  post_install_steps do
    remove "{{HOMEBREW_PREFIX}}/lib/ruby/gems/{{version.major_minor}}.0/gems/bundler-*", recursive: true
    on_macos do
      if_path_exists "opt/ruby@{{version.major_minor}}/lib/libruby.{{version.major_minor}}.dylib",
                     base: :homebrew_prefix do
        change_dylib_id "lib/libruby.dylib",
                        "{{HOMEBREW_PREFIX}}/opt/ruby@{{version.major_minor}}/" \
                        "lib/libruby.{{version.major_minor}}.dylib",
                        resolve_source: true
      end
    end
  end

  def rubygems_config
    <<~RUBY
      module Gem
        class << self
          alias :old_default_dir :default_dir
          alias :old_default_path :default_path
          alias :old_default_bindir :default_bindir
          alias :old_ruby :ruby
          alias :old_default_specifications_dir :default_specifications_dir
        end

        # TODO: enable this with Ruby 4.1
        #
        # def self.default_user_install
        #   return true unless ENV.key?("GEM_HOME")
        #
        #   false
        # end

        def self.default_dir
          path = [
            "#{HOMEBREW_PREFIX}",
            "lib",
            "ruby",
            "gems",
            RbConfig::CONFIG['ruby_version']
          ]

          @homebrew_path ||= File.join(*path)
        end

        def self.private_dir
          path = if defined? RUBY_FRAMEWORK_VERSION then
                   [
                     File.dirname(RbConfig::CONFIG['sitedir']),
                     'Gems',
                     RbConfig::CONFIG['ruby_version']
                   ]
                 elsif RbConfig::CONFIG['rubylibprefix'] then
                   [
                    RbConfig::CONFIG['rubylibprefix'],
                    'gems',
                    RbConfig::CONFIG['ruby_version']
                   ]
                 else
                   [
                     RbConfig::CONFIG['libdir'],
                     ruby_engine,
                     'gems',
                     RbConfig::CONFIG['ruby_version']
                   ]
                 end

          @private_dir ||= File.join(*path)
        end

        def self.default_path
          if Gem.user_home && File.exist?(Gem.user_home)
            [user_dir, default_dir, old_default_dir, private_dir]
          else
            [default_dir, old_default_dir, private_dir]
          end
        end

        def self.default_bindir
          "#{rubygems_bindir}"
        end

        def self.ruby
          "#{opt_bin}/ruby"
        end

        # https://github.com/Homebrew/homebrew-core/issues/40872#issuecomment-542092547
        # https://github.com/Homebrew/homebrew-core/pull/48329#issuecomment-584418161
        def self.default_specifications_dir
          File.join(Gem.old_default_dir, "specifications", "default")
        end
      end
    RUBY
  end

  def caveats
    # TODO: update path when enabling `Gem.default_user_install`
    <<~EOS
      By default, binaries installed by gem will be placed into:
        #{rubygems_bindir}

      You may want to add this to your PATH.
    EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby -e 'puts :hello'")
    assert_equal "hello\n", hello_text

    assert_equal api_version, determine_api_version

    ENV["GEM_HOME"] = testpath
    system bin/"gem", "install", "json"
    if OS.mac?
      parser = testpath.glob("gems/json-*/lib/json/ext/parser.bundle").first
      assert_includes MachO::Tools.dylibs(parser), "#{versioned_opt_prefix}/lib/libruby.#{version.major_minor}.dylib"
    end

    (testpath/"Gemfile").write <<~RUBY
      source 'https://rubygems.org'
      gem 'github-markup'
    RUBY
    system bin/"bundle", "exec", "ls" # https://github.com/Homebrew/homebrew-core/issues/53247
    system bin/"bundle", "install", "--binstubs=#{testpath}/bin"
    assert_path_exists testpath/"bin/github-markup", "github-markup is not installed in #{testpath}/bin"
  end
end
