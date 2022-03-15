class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2022.02/rakudo-star-2022.02.tar.gz"
  sha256 "49a2f9d440ffd443e59bf52b414220e4186b28c27a1984331d207d4c0e9b0968"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "13f29562a836448fb820c7efa93eb2fd635eda7b428635bce9002ccac1e28a6a"
    sha256 big_sur:       "a7dd4d2139e570762a78b60e505f62e581825732768ae49b4f9ca2ffc52bbb23"
    sha256 catalina:      "40bf7dfbdda3c1091dc5d4b8fd5a776ca8e6ba722b48fb7c536deb1914263096"
    sha256 mojave:        "4bb9fd2754e328dca6a7199f900a85bea5a673bd7ee4a1f47e330144eee81cff"
    sha256 x86_64_linux:  "1b05bf9ce1cf2b663b0f7c2b25332352db5a4e848df0b49b7b55ed49c298e5d1"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "libffi"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline"

  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.deparallelize # An intermittent race condition causes random build failures.

    # make install runs tests that can hang on sierra
    # set this variable to skip those tests
    ENV["NO_NETWORK_TESTING"] = "1"

    # openssl module's brew --prefix openssl probe fails so
    # set value here
    openssl_prefix = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_PREFIX"] = openssl_prefix.to_s

    system "bin/rstar", "install", "-p", prefix.to_s

    #  Installed scripts are now in share/perl/{site|vendor}/bin, so we need to symlink it too.
    bin.install_symlink Dir[share/"perl6/vendor/bin/*"]
    bin.install_symlink Dir[share/"perl6/site/bin/*"]

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    mv "#{prefix}/man", share if File.directory?("#{prefix}/man")
  end

  test do
    out = `#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
