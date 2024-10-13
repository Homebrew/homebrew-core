class Ruby < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  license "Ruby"
  head "https://github.com/ruby/ruby.git", branch: "master"

  stable do
    url "https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.5.tar.gz"
    sha256 "3781a3504222c2f26cb4b9eb9c1a12dbf4944d366ce24a9ff8cf99ecbce75196"

    # Should be updated only when Ruby is updated (if an update is available).
    # The exception is Rubygem security fixes, which mandate updating this
    # formula & the versioned equivalents and bumping the revisions.
    resource "rubygems" do
      url "https://rubygems.org/rubygems/rubygems-3.5.18.tgz"
      sha256 "a99163d03286850559134448e4c666fa32513407b63f1c277e5142b75180db56"

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
    sha256 arm64_sequoia:  "f473d3e051374e3fa2835015b4c3660f8bbb5c61fd9e45e73746563adee17102"
    sha256 arm64_sonoma:   "85786236ec92ca2e0cd40a7223345d3c7bf61f45e69da7b3433e0ef1019690e7"
    sha256 arm64_ventura:  "4bb00f47a4a6395c739d0624eb89957d1b9f708e332486822a72f450e077e80f"
    sha256 arm64_monterey: "91712cbb11cf8f2719579f983fd04d3414f6f59fc013b63d9b68f4867d64e7f1"
    sha256 sonoma:         "8ef5d62b67a3e0f98a9e18c9991322b33bed02d3ab738a820d426974394707c6"
    sha256 ventura:        "0f458a5c869f216f7f72122112363060667ac9c57df20a15bc74f1a78073d7a3"
    sha256 monterey:       "90800e40f73c5322054cad77de5cd4a5977f70cd34b610f0e3c4e96e1dde2af3"
    sha256 x86_64_linux:   "04add281c620f5ed78c8641d43f064280dfddcce67f7fde435a16e793f30b637"
  end

  keg_only :provided_by_macos

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
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

    return if build.head? # Use bundled RubyGems for --HEAD (will be newer)

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
      (libexec/"gembin").install buildpath/"vendor_gem/bin/bundle" => "bundle"
      (libexec/"gembin").install_symlink "bundle" => "bundler"
    end

    # remove all lockfiles in bin folder
    rm Dir[bin/"*.lock"]
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

    assert_equal api_version, determine_api_version

    ENV["GEM_HOME"] = testpath
    system bin/"gem", "install", "json"

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'github-markup'
    EOS
    system bin/"bundle", "exec", "ls" # https://github.com/Homebrew/homebrew-core/issues/53247
    system bin/"bundle", "install", "--binstubs=#{testpath}/bin"
    assert_predicate testpath/"bin/github-markup", :exist?, "github-markup is not installed in #{testpath}/bin"
  end
end
