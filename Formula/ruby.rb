class Ruby < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.2.tar.xz"
  sha256 "8be6b6afdf09957a6e2c2a6ada4b1982a391a828b34e49072c4beb60febb678d"

  bottle do
    sha256 "526209b8748df1669b9c73eab9e205627e9e2b249ac41765b12f76880a7296c6" => :mojave
    sha256 "0192b435eadc54981acc4db8aa3859f256a7a0468873d3462429d5baa7aff2d0" => :high_sierra
    sha256 "7d258f00243199129e9dc0b1e5bfda6ad50e94b637cd184d2e379390587ce063" => :sierra
  end

  devel do
    url "https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.0-preview2.tar.xz"
    version "2.6.0-preview2"
    sha256 "00ddfb5e33dee24469dd0b203597f7ecee66522ebb496f620f5815372ea2d3ec"
  end

  head do
    url "https://github.com/ruby/ruby.git"
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "readline"

  # Should be updated only when Ruby is updated (if an update is available).
  # The exception is Rubygem security fixes, which mandate updating this
  # formula & the versioned equivalents and bumping the revisions.
  resource "rubygems" do
    url "https://rubygems.org/rubygems/rubygems-2.7.7.tgz"
    sha256 "4cb2c9a36c0e4a3d5c20eb6795638632858fd72236d281963140221946ab55cb"
  end

  def api_version
    Utils.popen_read("#{bin}/ruby -e 'print Gem.ruby_api_version'")
  end

  def rubygems_bindir
    HOMEBREW_PREFIX/"bin"
  end

  def install
    # otherwise `gem` command breaks
    ENV.delete("SDKROOT")

    system "autoconf" if build.head?

    paths = %w[libyaml openssl readline].map { |f| Formula[f].opt_prefix }
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-silent-rules
      --with-sitedir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}/lib/ruby/vendor_ruby
      --with-opt-dir=#{paths.join(":")}
    ]
    args << "--disable-dtrace" unless MacOS::CLT.installed?

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

      # Remove bundled Rubygem version.
      rm_rf rg_in/"rubygems"
      rm_f rg_in/"rubygems.rb"
      rm_f rg_in/"ubygems.rb"
      rm_f bin/"gem"

      # Drop in the new version.
      rg_in.install Dir[buildpath/"vendor_gem/lib/*"]
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

  def rubygems_config(api_version); <<~EOS
    module Gem
      class << self
        alias :old_default_dir :default_dir
        alias :old_default_path :default_path
        alias :old_default_bindir :default_bindir
        alias :old_ruby :ruby
      end

      def self.default_dir
        path = [
          "#{HOMEBREW_PREFIX}",
          "lib",
          "ruby",
          "gems",
          "#{api_version}"
        ]

        @default_dir ||= File.join(*path)
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
          [user_dir, default_dir, private_dir]
        else
          [default_dir, private_dir]
        end
      end

      def self.default_bindir
        "#{rubygems_bindir}"
      end

      def self.ruby
        "#{opt_bin}/ruby"
      end
    end
  EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby -e 'puts :hello'")
    assert_equal "hello\n", hello_text
    ENV["GEM_HOME"] = testpath
    system "#{bin}/gem", "install", "json"

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'gemoji'
    EOS
    system rubygems_bindir/"bundle", "install", "--binstubs=#{testpath}/bin"
    assert_predicate testpath/"bin/gemoji", :exist?, "gemoji is not installed in #{testpath}/bin"
  end
end
