class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2024.02/rakudo-star-2024.02.tar.gz"
  sha256 "2dedea10ddcbc049423d18c57749c18ab7531f22afb6ce7d4091e7f2976298e4"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "dc89550195ead9d65fcf720618b45d07be78ed75d11a7aee73f61b6502c5ebf6"
    sha256 arm64_ventura:  "6eb7a699d0333b9a83d124e9f284dfe4f0fe479c7768bd182ee9d73e5dd772ab"
    sha256 arm64_monterey: "7e7d9c4f662cc3cf929b43975ab89a3b155d4248cde55129cfd5dbbfa43aa267"
    sha256 sonoma:         "05f2df24bec9e1868747b398ca90819ab816a64897cbd132ab02f7b202904f7d"
    sha256 ventura:        "ba945c8eec92dde80624f8a946308054407b33676d9bdc3943bc75d64f59356f"
    sha256 monterey:       "6256a8539a520c67e687c80428bff886127a14219a20a05448ca4eaa571cbd15"
    sha256 x86_64_linux:   "16d9afa5be1acb9820b40bb24ef6b6b5c76f1fd048e153db844317188ac9bd42"
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
