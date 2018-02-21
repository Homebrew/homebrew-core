class RubyAT18 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.bz2"
  sha256 "b4e34703137f7bfb8761c4ea474f7438d6ccf440b3d35f39cc5e4d4e239c07e3"
  revision 3

  bottle do
    sha256 "6fa2895dd8538acd306b765006112bb1e1abbe620ae1003e3cfd3fa404e6b648" => :high_sierra
    sha256 "69b10965f232420a01bf4d89e8803954e29d96cca486d1aa972c067149145433" => :sierra
    sha256 "bd377a1ee1116979787dc643e76ba0d346460a0c88203019450e72e0a3bd76a5" => :el_capitan
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

  def program_suffix
    build.with?("suffix") ? "187" : ""
  end

  def ruby
    "#{bin}/ruby#{program_suffix}"
  end

  def install
    # Compilation with `superenv` breaks because the Ruby build system sets
    # `RUBYLIB` and `RUBYOPT` and this disturbs the wrappers for `cc` and
    # `clang` that are provided by Homebrew and are implemented in Ruby. We
    # prefix those invocations with `env` to clean the environment for us.
    scrub_env = "/usr/bin/env RUBYLIB= RUBYOPT="
    inreplace "mkconfig.rb", "    if /^prefix$/ =~ name\n",
              <<~EOS.gsub(/^/, "    ")
                # `env` removes stuff that will break `superenv`.
                if %w[CC CPP LDSHARED LIBRUBY_LDSHARED].include?(name)
                  val = val.sub("\\"", "\\"#{scrub_env} ")
                end
                if /^prefix$/ =~ name
              EOS

    args = %W[
      --prefix=#{prefix}
      --enable-shared
    ]

    args << "--program-suffix=#{program_suffix}" if build.with? "suffix"
    args << "--enable-install-doc" if build.with? "doc"

    rm_r "ext/tk" if build.without? "tcltk"

    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "install-doc" if build.with? "doc"
  end

  test do
    hello_text = shell_output("#{bin}/ruby#{program_suffix} -e 'puts :hello'")
    assert_equal "hello\n", hello_text
    system "#{bin}/ruby#{program_suffix}", "-e", "require 'zlib'"
  end
end
