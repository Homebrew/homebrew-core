class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2022.06/rakudo-star-2022.06.tar.gz"
  sha256 "1248ae17aa0f361d8b551a8957bc5b7f8dcda4c02b3839d0f80877f86397bc09"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_monterey: "73ad9d434e8981bbe21d6e32d686c0bc701831307103593a705c48d02cab0bce"
    sha256 arm64_big_sur:  "1c70fdc2578ae2699f55da86c622d9441b0543543832c2a72d33af609a8ff984"
    sha256 monterey:       "50653692820d3ee7bb2e107f2060b2b2b967505fd72d1db0795de3f27e550879"
    sha256 big_sur:        "d52db1acb6d960b71d5523a0fb19c8831c301e27975b477735fba875916c8195"
    sha256 catalina:       "66c29b1fd2015609a996c816091507e42837d1be9b0e3dd5731730980fc0c4cb"
    sha256 x86_64_linux:   "53ece8d41dcd7502eb1d58c32e67897f9cfa8bc72e2c8a5473b11a03b2b22d17"
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
