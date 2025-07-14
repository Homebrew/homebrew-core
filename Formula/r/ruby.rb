class Ruby < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  license "Ruby"
  head "https://github.com/ruby/ruby.git", branch: "master"

  stable do
    # Consider changing the default of `Gem.default_user_install` to true with Ruby 3.5.
    # This may depend on https://github.com/rubygems/rubygems/issues/5682.
    url "https://cache.ruby-lang.org/pub/ruby/3.4/ruby-3.4.4.tar.gz"
    sha256 "a0597bfdf312e010efd1effaa8d7f1d7833146fdc17950caa8158ffa3dcbfa85"

    # Should be updated only when Ruby is updated (if an update is available).
    # The exception is Rubygem security fixes, which mandate updating this
    # formula & the versioned equivalents and bumping the revisions.
    resource "rubygems" do
      url "https://rubygems.org/rubygems/rubygems-3.6.9.tgz"
      sha256 "ffdd46c6adbecb9dac561cc003666406efd2ed93ca21b5fcc47062025007209d"

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
    rebuild 1
    sha256 arm64_sequoia: "f91b9870507ed4690914424ea6693cad133a75d062654425fd99b803e37a4d93"
    sha256 arm64_sonoma:  "c3adf737845d90aa0677eeb0aa0e47d32df406960b75833db68891f73ef849a2"
    sha256 arm64_ventura: "f65125606d3279b2262a25acb629dc429de665ae7b0a29042be2c20d3b2005e4"
    sha256 sonoma:        "8086f57d95bbfd253a10310b9da36898cee6955b25d431321acac817cbb2a298"
    sha256 ventura:       "6dff743916412b2227ee851825737eae59db2696b875120573dfb11b401715d7"
    sha256 arm64_linux:   "da3abe8bcda1a43b342663d0c668b57ded83b522cd03d01c38a99110ca722d78"
    sha256 x86_64_linux:  "7d0295b03469cb59ca833318acb453d641406e1a7c07f5761fcd4fe3b6ddbcd3"
  end

  keg_only :provided_by_macos

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "openssl@3"

  uses_from_macos "gperf"
  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

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

  def install
    # otherwise `gem` command breaks
    ENV.delete("SDKROOT")

    # Prevent `make` from trying to install headers into the SDK
    # TODO: Remove this workaround when the following PR is merged/resolved:
    #       https://github.com/Homebrew/brew/pull/12508
    inreplace "tool/mkconfig.rb", /^(\s+val = )'"\$\(SDKROOT\)"'\+/, "\\1"

    system "./autogen.sh" if build.head?

    paths = %w[libyaml openssl@3].map { |f| Formula[f].opt_prefix }
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

    # Correct MJIT_CC to not use superenv shim
    args << "MJIT_CC=/usr/bin/#{DevelopmentTools.default_compiler}"

    # Avoid stdckdint.h on macOS 15 as it's not available in Xcode 16.0-16.2,
    # and if the build system picks it up it'll use it for runtime builds too.
    args << "ac_cv_header_stdckdint_h=no" if OS.mac? && MacOS.version == :sequoia

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

    unless build.head? # Use bundled RubyGems for --HEAD (will be newer)
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

    assert_equal api_version, determine_api_version

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
