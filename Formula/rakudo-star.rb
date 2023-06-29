class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2023.06/rakudo-star-2023.06.tar.gz"
  sha256 "15b930c16655851ae168d639632b02a674ef0010adc9d84bb1328d5bc33dcadd"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_ventura:  "e409b1a493672426efe2f55ce8e522d44b19b285b066bfde6f87543224ca4b83"
    sha256 arm64_monterey: "be54df0a3edec0db18b916809163446c896e2477e12f60f5697242b89c685e1b"
    sha256 arm64_big_sur:  "3a5afe45485288c6d5abc4383eec46d6fbfcf1c6b09718783a99b139f1b4da0b"
    sha256 ventura:        "d932dd3632ae6e0cdd8b8108df73ddf6813fb9e4556d3fc55ffaffc7e53b67ee"
    sha256 monterey:       "3ce172e6b9a7cb8cad369403c0ffd89a2a56f4f26707e52c24407da3a0f05ef8"
    sha256 big_sur:        "ed5f11b4aab8edd5f562999ccf1e9aac2caafb2caa93c3ff672f64ab70d1b155"
    sha256 x86_64_linux:   "56cbf97f14a0dcfdda7892b30351e88f476f98134d4eae997d79984f24b26d5a"
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
