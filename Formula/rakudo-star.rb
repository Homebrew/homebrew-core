class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2022.07/rakudo-star-2022.07.tar.gz"
  sha256 "f2c9819cb37ce82e278c4da5a2512cd9a333cac55c21874cf2f388bd9d888537"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_ventura:  "e4f5ae151278cb5fb810f5ce565c2b05daa263676a379b714cdf457af46a9a9f"
    sha256 arm64_monterey: "c5c7589ad46acbb86c7423230a19a34680d9d89301b8a9955d2a31381e048203"
    sha256 arm64_big_sur:  "b859246558c204289f96102525415db6c2af6f38164bf5171c9cebce9b742029"
    sha256 ventura:        "5a8d85fb3ea50faa403f01af49741dd004adeed56df9957a511c160cb451c929"
    sha256 monterey:       "007f997e227f2e6e6d650860a51d0caf278fa22c8f1fbf013b286f78b113c122"
    sha256 big_sur:        "35b4078ff31ea851fbf22de0a7d5c999abaad8f7418e8647a5efa36e2a91282e"
    sha256 catalina:       "895ed52824e3f7654e011b87352c1473779e899713f59599d53564389d38f555"
    sha256 x86_64_linux:   "64e8b85ddf8bc4d20bede59a75f490b3ddd0d19f5e80ea1f68217e6db8844481"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline"
  uses_from_macos "libffi", since: :catalina

  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  def install
    if MacOS.version < :catalina
      libffi = Formula["libffi"]
      ENV.remove "CPPFLAGS", "-I#{libffi.include}"
      ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"
    end

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
    bin.install_symlink (share/"perl6/vendor/bin").children
    bin.install_symlink (share/"perl6/site/bin").children

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    share.install prefix/"man" if (prefix/"man").directory?
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
