class RubyAT32 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.4.tar.gz"
  sha256 "c72b3c5c30482dca18b0f868c9075f3f47d8168eaf626d4e682ce5b59c858692"
  license "Ruby"

  livecheck do
    url "https://www.ruby-lang.org/en/downloads/"
    regex(/href=.*?ruby[._-]v?(3\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e53e897164a68ad3d027a4dce50742a1f20130d849c1cb3bcc58ab1200ea122b"
    sha256 arm64_ventura:  "d52c90c5f9048725ffdef1ecd609ee2deb256369493429cb6dcc31f0456c4216"
    sha256 arm64_monterey: "a707434a60ac044067c8dd1817c2d176fe5e620cce5640465b286037539363c7"
    sha256 sonoma:         "aedc9fa3b5ab822f07d51027b924e05fb825a1d17ee1b5f6a88d5a5a239ce76d"
    sha256 ventura:        "ab0e542f51c3b669561a2a0a1a0ca9084de4fee7f57722b74b204dbcb3f7375e"
    sha256 monterey:       "7c6657eedc19f12724fa6c8b843509676b188d80b6491b1ebfc4d4f8fcbf2717"
    sha256 x86_64_linux:   "51fa1767613a571a8f091b137bbc0e0635d4adb4d5a766beb7238223afaa2ee8"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "gperf"
  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  # Should be updated only when Ruby is updated (if an update is available).
  # The exception is Rubygem security fixes, which mandate updating this
  # formula & the versioned equivalents and bumping the revisions.
  resource "rubygems" do
    url "https://rubygems.org/rubygems/rubygems-3.5.9.tgz"
    sha256 "2b203642191e6bb9ece19075f62275a88526319b124684c46667415dca4363f1"
  end

  def api_version
    "3.2.0"
  end

  def rubygems_bindir
    HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/bin"
  end

  def install
    # otherwise `gem` command breaks
    ENV.delete("SDKROOT")

    # Prevent `make` from trying to install headers into the SDK
    # TODO: Remove this workaround when the following PR is merged/resolved:
    #       https://github.com/Homebrew/brew/pull/12508
    inreplace "tool/mkconfig.rb", /^(\s+val = )'"\$\(SDKROOT\)"'\+/, "\\1"

    paths = %w[libyaml openssl@3 readline].map { |f| Formula[f].opt_prefix }
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-silent-rules
      --with-sitedir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}/lib/ruby/vendor_ruby
      --with-opt-dir=#{paths.join(":")}
      --without-gmp
    ]
    args << "--disable-dtrace" if OS.mac? && !MacOS::CLT.installed?

    # Correct MJIT_CC to not use superenv shim
    args << "MJIT_CC=/usr/bin/#{DevelopmentTools.default_compiler}"

    system "./configure", *args

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

    system "make"
    system "make", "install"

    # A newer version of ruby-mode.el is shipped with Emacs
    elisp.install Dir["misc/*.el"].reject { |f| f == "misc/ruby-mode.el" }

    # This is easier than trying to keep both current & versioned Ruby
    # formulae repeatedly updated with Rubygem patches.
    resource("rubygems").stage do
      ENV.prepend_path "PATH", bin

      system "#{bin}/ruby", "setup.rb", "--prefix=#{buildpath}/vendor_gem"
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
      (libexec/"gembin").install buildpath/"vendor_gem/bin/bundle" => "bundle"
      (libexec/"gembin").install_symlink "bundle" => "bundler"
    end
  end

  def post_install
    # Since Gem ships Bundle we want to provide that full/expected installation
    # but to do so we need to handle the case where someone has previously
    # installed bundle manually via `gem install`.
    rm_f %W[
      #{rubygems_bindir}/bundle
      #{rubygems_bindir}/bundler
    ]
    rm_rf Dir[HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/gems/bundler-*"]
    rubygems_bindir.install_symlink Dir[libexec/"gembin/*"]

    # Customize rubygems to look/install in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib/"ruby/#{api_version}/rubygems/defaults/operating_system.rb"
    config_file.unlink if config_file.exist?
    config_file.write rubygems_config(api_version)

    # Create the sitedir and vendordir that were skipped during install
    %w[sitearchdir vendorarchdir].each do |dir|
      mkdir_p `#{bin}/ruby -rrbconfig -e 'print RbConfig::CONFIG["#{dir}"]'`
    end
  end

  def rubygems_config(api_version)
    <<~EOS
      module Gem
        class << self
          alias :old_default_dir :default_dir
          alias :old_default_path :default_path
          alias :old_default_bindir :default_bindir
          alias :old_ruby :ruby
          alias :old_default_specifications_dir :default_specifications_dir
        end

        def self.default_dir
          path = [
            "#{HOMEBREW_PREFIX}",
            "lib",
            "ruby",
            "gems",
            "#{api_version}"
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
    EOS
  end

  def caveats
    <<~EOS
      By default, binaries installed by gem will be placed into:
        #{rubygems_bindir}

      You may want to add this to your PATH.
    EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby -e 'puts :hello'")
    assert_equal "hello\n", hello_text

    assert_equal api_version, shell_output("#{bin}/ruby -e 'print Gem.ruby_api_version'")

    ENV["GEM_HOME"] = testpath
    system "#{bin}/gem", "install", "json"

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'github-markup'
    EOS
    system bin/"bundle", "exec", "ls" # https://github.com/Homebrew/homebrew-core/issues/53247
    system bin/"bundle", "install", "--binstubs=#{testpath}/bin"
    assert_predicate testpath/"bin/github-markup", :exist?, "github-markup is not installed in #{testpath}/bin"
  end
end
