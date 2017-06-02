class RubyAT18 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.bz2"
  sha256 "b4e34703137f7bfb8761c4ea474f7438d6ccf440b3d35f39cc5e4d4e239c07e3"
  revision 2

  bottle do
    sha256 "b7b546e51dd2db5c2cd656998041af71fb45bbb766d0806b80307c0af0beeb7c" => :sierra
    sha256 "4ace3a1054114b29c38852966aac76140570981958cf44e74267fc92f30ad13e" => :el_capitan
    sha256 "9940035c29b4c2949d60e277bd0cadd8f52d074e4a1259435f95e8e1174283d4" => :yosemite
  end

  keg_only :versioned_formula

  option "with-suffix", "Suffix commands with '187'"
  option "with-doc", "Install documentation"
  option "with-tcltk", "Install with Tcl/Tk support"

  depends_on "pkg-config" => :build
  depends_on "readline" => :recommended
  depends_on "gdbm" => :optional
  depends_on "openssl"
  depends_on :x11 if build.with? "tcltk"

  resource "rubygems" do
    url "https://rubygems.org/rubygems/rubygems-2.5.0.tgz"
    sha256 "a39e95acb86f52fdca38b1484b2eed61a7f76551119079d7a9f8c67c5be78831"
  end

  def install
    # Compilation with `superenv` breaks because the Ruby build system sets
    # `RUBYLIB` and `RUBYOPT` and this disturbs the wrappers for `cc` and
    # `clang` that are provided by Homebrew and are implemented in Ruby. We
    # prefix those invocations with `env` to clean the environment for us.
    scrub_env = "/usr/bin/env RUBYLIB= RUBYOPT="
    inreplace "mkconfig.rb", "    if /^prefix$/ =~ name\n",
              <<-EOS.undent.gsub(/^/, "    ")
                # `env` removes stuff that will break `superenv`.
                if %w[CC CPP LDSHARED LIBRUBY_LDSHARED].include?(name)
                  val = val.sub("\\"", "\\"#{scrub_env} ")
                end
                if /^prefix$/ =~ name
              EOS

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-sitedir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}/lib/ruby/vendor_ruby
    ]

    args << "--program-suffix=#{program_suffix}" if build.with? "suffix"
    args << "--enable-install-doc" if build.with? "doc"

    rm_r "ext/tk" if build.without? "tcltk"

    system "./configure", *args

    # Ruby has been configured to look in the HOMEBREW_PREFIX for the
    # sitedir and vendordir directories; however we don't actually want to create
    # them during the install.
    #
    # These directories are empty on install; sitedir is used for non-rubygems
    # third party libraries, and vendordir is used for packager-provided libraries.
    inreplace "instruby.rb" do |s|
      s.gsub! "\n    makedirs [archlibdir, sitearchlibdir, vendorarchlibdir]\n",
              "\n    makedirs [archlibdir]\n"
      s.gsub! "\n    makedirs [rubylibdir, sitelibdir, vendorlibdir]\n",
              "\n    makedirs [rubylibdir]\n"
    end

    system "make"
    system "make", "install"
    system "make", "install-doc" if build.with? "doc"

    # Install rubygems into its own prefix, then move into the right place, as
    # we cannot easily make it install where it should be and the defaults are
    # no good and would cause a sandbox violation.
    resource("rubygems").stage do
      system "#{bin}/ruby#{program_suffix}", "setup.rb", "--prefix=#{prefix}/gem"
      mv (prefix/"gem/bin").children, bin
      mv (prefix/"gem/lib").children, lib/"ruby/#{abi_version}"
      rm_r prefix/"gem"
    end
  end

  def post_install
    # Customize rubygems to look/install in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib/"ruby/#{abi_version}/rubygems/defaults/operating_system.rb"
    config_file.unlink if config_file.exist?
    config_file.write rubygems_config

    # Create the sitedir and vendordir that were skipped during install
    ruby="#{bin}/ruby#{program_suffix}"
    %w[sitearchdir vendorarchdir].each do |dir|
      mkdir_p `#{ruby} -rrbconfig -e 'print RbConfig::CONFIG["#{dir}"]'`
    end

    # Create the version-specific bindir used by rubygems
    mkdir_p rubygems_bindir
  end

  def abi_version
    "1.8"
  end

  def program_suffix
    build.with?("suffix") ? "187" : ""
  end

  def rubygems_bindir
    "#{HOMEBREW_PREFIX}/lib/ruby/gems/#{abi_version}/bin"
  end

  def rubygems_config; <<-EOS.undent
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
          "#{abi_version}"
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
        "#{opt_bin}/ruby#{program_suffix}"
      end
    end
    EOS
  end

  def caveats; <<-EOS.undent
    By default, binaries installed by gem will be placed into:
      #{rubygems_bindir}

    You may want to add this to your PATH.
    EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby#{program_suffix} -e 'puts :hello'")
    assert_equal "hello\n", hello_text
    system "#{bin}/ruby#{program_suffix}", "-e", "require 'zlib'"
    system "#{bin}/gem#{program_suffix}", "list", "--local"
  end
end
