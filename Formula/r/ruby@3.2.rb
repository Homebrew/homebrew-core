class RubyAT32 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.9.tar.gz"
  sha256 "abbad98db9aeb152773b0d35868e50003b8c467f3d06152577c4dfed9d88ed2a"
  license "Ruby"
  revision 1

  livecheck do
    url "https://www.ruby-lang.org/en/downloads/"
    regex(/href=.*?ruby[._-]v?(3\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "850eb4a323d765ee686a0ef2cba9a79a2ad4b581b3c22c5c9a263a38c019c68d"
    sha256 arm64_sequoia: "c0333a8d58a19c18dd1dfd2fc4d794e0b56683a6263dbfb7b6e7d8c31ee8916e"
    sha256 arm64_sonoma:  "a1c5d10b027435c318c39a0f35592f5b5329a68a0d928ba6081f3337ae39af74"
    sha256 sonoma:        "12d8ff67cd5fd2dc4b1ca2b5a0fca0c85ff8ef287fa0cac6932e4a1ada24c999"
    sha256 arm64_linux:   "d7399b88bbc194a82cc7d89c4aca3988b978c065ee6f5020e12fbce4bcaee37a"
    sha256 x86_64_linux:  "a5990cbc9859fad46e2d5ed3d255bb306d67b6061460e89aa76a31cc11faf793"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "gperf"
  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Should be updated only when Ruby is updated (if an update is available).
  # The exception is Rubygem security fixes, which mandate updating this
  # formula & the versioned equivalents and bumping the revisions.
  resource "rubygems" do
    url "https://rubygems.org/rubygems/rubygems-3.7.1.tgz"
    sha256 "750c8c771180d41ed2358344e5461edee83158c0a81b779969a1339961bc1163"

    livecheck do
      url "https://rubygems.org/pages/download"
      regex(/href=.*?rubygems[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
  end

  # Update the bundled openssl gem for compatibility with OpenSSL 3.6+
  # Using 3.1.x series to match major/minor version of bundled gem
  resource "openssl" do
    url "https://github.com/ruby/openssl/archive/refs/tags/v3.1.2.tar.gz"
    sha256 "0abb96cdeaef1c0a2bfc8e0a4557467d7f2e93cabdd00d0d387afb1d0e1569a9"
  end

  def api_version
    "3.2.0"
  end

  def rubygems_bindir
    HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/bin"
  end

  def install
    openssl_gem_version = File.read("ext/openssl/openssl.gemspec")[/spec\.version\s*=\s*"(\d+(?:\.\d+)+)/, 1]
    odie "Remove openssl resource!" if Version.new(openssl_gem_version) >= "3.1.2"
    rm_r(%w[ext/openssl test/openssl])
    resource("openssl").stage do
      (buildpath/"ext").install "ext/openssl"
      (buildpath/"ext/openssl").install "lib", "History.md", "openssl.gemspec"
      (buildpath/"test").install "test/openssl"
    end

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

    if OS.linux?
      arch = Utils.safe_popen_read(
        bin/"ruby", "-rrbconfig", "-e", 'print RbConfig::CONFIG["arch"]'
      ).chomp
      # Don't restrict to a specific GCC compiler binary we used (e.g. gcc-5).
      inreplace lib/"ruby/#{api_version}/#{arch}/rbconfig.rb" do |s|
        s.gsub! ENV.cxx, "c++"
        s.gsub! ENV.cc, "cc"
        # Change e.g. `CONFIG["AR"] = "gcc-ar-11"` to `CONFIG["AR"] = "ar"`
        s.gsub!(/(CONFIG\[".+"\] = )"(?:gcc|g\+\+)-(.*)-\d+"/, '\\1"\\2"')
      end
    end

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

    # Customize rubygems to look/install in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib/"ruby/#{api_version}/rubygems/defaults/operating_system.rb"
    config_file.write rubygems_config
  end

  def post_install
    # Since Gem ships Bundle we want to provide that full/expected installation
    # but to do so we need to handle the case where someone has previously
    # installed bundle manually via `gem install`.
    rm(%W[
      #{rubygems_bindir}/bundle
      #{rubygems_bindir}/bundler
    ].select { |file| File.exist?(file) })
    rm_r(Dir[HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/gems/bundler-*"])
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
    system bin/"gem", "install", "json"

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'github-markup'
    EOS
    system bin/"bundle", "exec", "ls" # https://github.com/Homebrew/homebrew-core/issues/53247
    system bin/"bundle", "install", "--binstubs=#{testpath}/bin"
    assert_path_exists testpath/"bin/github-markup", "github-markup is not installed in #{testpath}/bin"
  end
end
