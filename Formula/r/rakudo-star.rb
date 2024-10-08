class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2024.09/rakudo-star-2024.09.tar.gz"
  sha256 "5b320e963aae8c0345b3ecb9a3d7baaf377729d256548cdafb246076ce65555b"
  license "Artistic-2.0"
  revision 1

  bottle do
    sha256 arm64_sequoia: "ed0f866c75d5956261d375bcd666de04020906a1675e61186421fe109b50c180"
    sha256 arm64_sonoma:  "90c8f0b3cc519445cfdaf913853ed17a8b76d319137ea44822a4044714c6d1ca"
    sha256 arm64_ventura: "122ab41ad41f9620cfc55290da6a4989799fb4a223c7c8fa3f0ad0cd6d82bb70"
    sha256 sonoma:        "baca08ff3b3ae0df9126740b8a8fc2bb8358ca338c0f5ff7b1ecc46dffc0a285"
    sha256 ventura:       "afac32d41fc59e0ceaa8aebe2ab8f811b8e549fde8826d422b8b348ef39b6398"
    sha256 x86_64_linux:  "14c9e4954c654cc1ebc2071cc125e4ae3555c2e4b3d984de0b2c539b77b3606d"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c@75"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline"
  uses_from_macos "libffi", since: :catalina

  conflicts_with "moar", because: "both install `moar` binaries"
  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  def install
    if !OS.mac? || MacOS.version < :catalina
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
