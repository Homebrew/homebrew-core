class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://rakudo.org/dl/star/rakudo-star-2020.05.tar.gz"
  sha256 "d0d0a4ed5f75a5fb010d9630c052c061df9b6ce8325d578fae21fc6a4b99e6d6"
  license "Artistic-2.0"
  revision 1

  livecheck do
    url "https://rakudo.org/dl/star/"
    regex(/".*?rakudo-star[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "3b278aad10dae56ebb623fecdc5cd8e044d1bb23021a48e4c4428554674cb89e" => :catalina
    sha256 "c0ad291ef64244dec178ecb1c878ca8e921123c70e408b8f8f96dc64d2364248" => :mojave
    sha256 "0938d963dc23119a1c4a2fa976d4b870f81d744c41986f122aad15858c0b9717" => :high_sierra
  end

  depends_on "bash"
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "libffi"
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
