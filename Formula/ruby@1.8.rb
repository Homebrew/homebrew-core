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
    sha256 "7c6d46159711bc9024aac359d3bf1434bc190939d44573c3084c68b4060c9f36" => :mojave
    sha256 "1a4f800a8db04522cefca4019d9100d7745e66db6caf253641a82bfe7cf9422c" => :high_sierra
    sha256 "491e3b677ebb4fc688f6453457c3f540f7854c5fc13f34f42a8c25fb278b7d79" => :sierra
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
