class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2023.05/rakudo-star-2023.05.tar.gz"
  sha256 "54663e8966a633f5a51eee06c8fdae3a16aaa2efa2f046c7c89389c007dfc7a5"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_ventura:  "8c7850c4faf1dc7be3fcc80eecb4cb1bbdc64038b1063af9c377d374f3b36bc9"
    sha256 arm64_monterey: "e15d772ae2f2394fec3fa68ea8a71ca73db2a85060bcadda2f24a4601ca01f47"
    sha256 arm64_big_sur:  "5eb57de2af019b4f382ee3300ca380f736e4b1750d34f264ef44a4cd88db4259"
    sha256 ventura:        "e2f1a6b887c190c7f352d3fdc81af1d7d5ef6efe833705104dec13a4df3d50e2"
    sha256 monterey:       "d0aabaaf9ee264b27b4295456b71e6e8fc3b6423b6da85cd83f4ca0af034a7c3"
    sha256 big_sur:        "0155a6e9045a86bee75b35b8dd84ea4ef445210d18b75dd7de981f2e0476609a"
    sha256 x86_64_linux:   "a7a7dafa1457d7b0ec45639dcb843224218cb4e5a2a7b66aa25e8e4fba082b51"
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
