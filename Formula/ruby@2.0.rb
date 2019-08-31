# This formula should never be deleted even when it is in violation of
# https://docs.brew.sh/Versions. This is because it is useful to test things
# with Ruby 2.0 for reproducing Ruby issues with older versions of macOS that
# used this version (e.g. on 10.10 - 10.12 the system Ruby is 2.0).

class RubyAT20 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p648.tar.bz2"
  sha256 "087ad4dec748cfe665c856dbfbabdee5520268e94bb81a1d8565d76c3cc62166"
  revision 7

  bottle do
    sha256 "d30efcdddc1d6a16b49ac8b5211465db73bb6d2d30a4589a27ad3ade5b3c6638" => :mojave
    sha256 "e1c78d0123df94ad006117f44c823e8cb6ee8fde2f386f3a8f03ea1c24725cc2" => :high_sierra
    sha256 "7fb2817eecc933fc659f6c9a502fe0e6836f698db7aeed4d831fd36bea97ed8a" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "libyaml"
  depends_on "openssl" # no OpenSSL 1.1 support
  depends_on "readline"

  def api_version
    "2.0.0"
  end

  def rubygems_bindir
    HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/bin"
  end

  def install
    paths = %w[libyaml openssl readline].map { |f| Formula[f].opt_prefix }
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-sitedir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}/lib/ruby/vendor_ruby
      --with-opt-dir=#{paths.join(":")}
      --with-out-ext=tk
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
    config_file.write rubygems_config

    # Create the sitedir and vendordir that were skipped during install
    %w[sitearchdir vendorarchdir].each do |dir|
      mkdir_p `#{bin}/ruby -rrbconfig -e 'print RbConfig::CONFIG["#{dir}"]'`
    end
  end

  def rubygems_config; <<~EOS
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

  def caveats; <<~EOS
    By default, binaries installed by gem will be placed into:
      #{rubygems_bindir}

    You may want to add this to your PATH.
  EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby -e 'puts :hello'")
    assert_equal "hello\n", hello_text
    ENV["GEM_HOME"] = testpath
    system "#{bin}/gem", "install", "json"
  end
end
