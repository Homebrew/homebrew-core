# This formula should never be deleted even when it is in violation of
# https://docs.brew.sh/Versions. This is because it is useful to test things
# with Ruby 1.8 for reproducing Ruby issues with older versions of macOS that
# used this version (e.g. on <=10.9 the system Ruby is 1.8 and we build our
# portable Ruby on 10.5).

class RubyAT18 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.bz2"
  sha256 "b4e34703137f7bfb8761c4ea474f7438d6ccf440b3d35f39cc5e4d4e239c07e3"
  revision 5

  bottle do
    sha256 "34ac66b428a1fd4da537d73c9b05217e9bcddd61f1a9f2de313c737eca86d49c" => :mojave
    sha256 "028a474aad330d68cb05970f5587e30d98a6442dc847d30371c9dc4dfac3a9f8" => :high_sierra
    sha256 "cde0dd03d2eeaa2d9e98f7b0ca88c1f362049f3de5b631ff9ca87d64360fe641" => :sierra
    sha256 "d8993792dd522fe5977604d704337bf9845447db9d0274a173b16b7290d24ebf" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "readline"

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

    rm_r "ext/tk"

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-install-doc
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "install-doc"
  end

  test do
    hello_text = shell_output("#{bin}/ruby -e 'puts :hello'")
    assert_equal "hello\n", hello_text
    system "#{bin}/ruby", "-e", "require 'zlib'"
  end
end
