class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2023.08/rakudo-star-2023.08.tar.gz"
  sha256 "baf44caa0ebe143c1dfb78bf8592b8eab79f7dc892787e369c2dc1a255dac0be"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_ventura:  "5b453e990dd5b14737332647897c210029da3b7d27aaafd9c41ecb655a56e04d"
    sha256 arm64_monterey: "bf45d047fed747bbec82211fc15b18cb66c364ffac0271da577d62b9ff8bf109"
    sha256 arm64_big_sur:  "50fea3fd18f01c13d1cba0ce4563305712279fe0af204c81a5848dc00c464efe"
    sha256 ventura:        "c05798b1277a6cca53261850a5b2b4b2feec036a3e9aa12acc2b4c477846d5bf"
    sha256 monterey:       "268856265bd576fd2e9939f35694bf23c4091fa14231d92cb4c4a557f757d6e7"
    sha256 big_sur:        "ec0b18547c1ac3c23d7645b1883a27c5482ec90ef1845e2b0a9eeed86aedcd38"
    sha256 x86_64_linux:   "958c985e7ef23c57846010240ca7bde01b98db52ac39e8607901835830a8f6a8"
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
