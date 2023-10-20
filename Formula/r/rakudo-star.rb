class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2023.10/rakudo-star-2023.10.tar.gz"
  sha256 "4c5fb2bd521ac2bcb9f747bb854fe1682dd64a6e69d3636e4101f6c6b5cdcd95"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "6be6f2da76ba18e86892af0c94f6e3a5823fe4753ab548c3ca7bbdcdebaff154"
    sha256 arm64_ventura:  "6ad2b86f7e12318103493e6dfcc553e3ea32feab4e71fdf00e20f226ea1a45a2"
    sha256 arm64_monterey: "8a8d98e092eefa86139187c9d8be47c27c79db8612ed8533b72d2eda558486aa"
    sha256 arm64_big_sur:  "0042e6231dfba9a0ee6b90b1f6b0e1bb90189fc6a7b0c4af477dd28b2cc10bab"
    sha256 sonoma:         "676211df17920a4190dc0b823850b7d3a7097b81531bf7f3b3cace44c38171e9"
    sha256 ventura:        "fd8ef482465fe495a84039e1cf0e1aec8a01a0601b9bb1a4a8e21a512868eb07"
    sha256 monterey:       "a0cffe2e20723b6ea29cf5ad7b0708387227dea86fadab81b6f78f4cbd5129ff"
    sha256 big_sur:        "67a27c86b131bcfdb7f884a794e45acf193d1e7dacbd2432f4c78a65f159fc5f"
    sha256 x86_64_linux:   "22ac1b2fd3469f05fa7ed0c911795cbe529ca8ee0dcaed5aa13769268d411a58"
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
