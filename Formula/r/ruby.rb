class Ruby < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  license "Ruby"
  compatibility_version 1

  stable do
    url "https://cache.ruby-lang.org/pub/ruby/4.1/ruby-4.1.0-preview1.tar.gz"
    version "4.1.0-beta1"
    sha256 "fb530bb88e90de3ae91c1310a27ae090e6bd989b8726de50ef12a890a85b88ef"

    # Should be updated only when Ruby is updated (if an update is available).
    # The exception is Rubygem security fixes, which mandate updating this
    # formula & the versioned equivalents and bumping the revisions.
    resource "rubygems" do
      url "https://rubygems.org/rubygems/rubygems-4.1.0.beta2.tgz"
      sha256 "8a9d6692b72890214b98adcf53d5c48169f05a6631b5cff44e0fead91676f8da"

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
    sha256 arm64_golden_gate: "42c252a757b8794b20229dc2f3d4b642bc5c7b293c1e454068047316daf99b70"
    sha256 arm64_tahoe:       "c5f5264f6b1484a038cfdf0fc444348adc36f8588c11ecfe1dbbeba37b3d426a"
    sha256 arm64_sequoia:     "b65a871b19ebcedb14e1ba06a3f365f09f3573a56fc2daf5aa413dbb79ef18f9"
    sha256 arm64_linux:       "0adcca64574f55a9504aaf05f24dc923d67534f590b9ea4a774d9b14e29f345a"
    sha256 x86_64_linux:      "712b24ac5b6a081e3d0ae59861b0dfdf2586562367bac34876a1b396fccfc8f5"
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
      "#{version.major.to_i}.#{version.minor.to_i}.0+5"
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

    # Customize rubygems to look for shared gems in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib/"ruby/#{api_version}/rubygems/defaults/operating_system.rb"
    config_file.write rubygems_config
  end

  post_install_steps do
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

        def self.default_user_install
          !ENV.key?("GEM_HOME")
        end

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
    <<~EOS
      Gems are installed to your user directory by default. Add their executables
      to your PATH with:
        export PATH="$(#{opt_bin}/ruby -e 'print Gem.user_dir')/bin:$PATH"
    EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby -e 'puts :hello'")
    assert_equal "hello\n", hello_text

    assert_equal api_version, determine_api_version

    ENV.delete("GEM_HOME")
    user_bin = Pathname(shell_output("#{bin}/ruby -e 'print Gem.user_dir'").strip)/"bin"
    system bin/"gem", "install", "rake", "--no-document"
    (testpath/"Rakefile").write 'task(:default) { puts "hello" }'
    assert_equal "hello\n", shell_output(user_bin/"rake")

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
