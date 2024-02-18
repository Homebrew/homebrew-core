class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2024.01/rakudo-star-2024.01.tar.gz"
  sha256 "190d79124f8fdc8fba2e44052bac0c1990339719e447de128c2b23cc30e8566b"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "da753d0f9060e7d34f6c537178bcf95cdec656851deceeaa911af0e94ea7de02"
    sha256 arm64_ventura:  "622e28f44f9b9ed742eaded14aea60655219c55c1a3a6c67f4fb73fccb0c21e6"
    sha256 arm64_monterey: "3432eb160c07c6e8f278b27f87099a8276c8968b6d786f69bdc499ac6b78e351"
    sha256 sonoma:         "9e0376535c30cd83837786e60467ecbbdeb74884428be7d17214c013b0e13eef"
    sha256 ventura:        "7cbe263d12c0094543ea7d39c159984b4d448edc068fae866f0b829dd97337ca"
    sha256 monterey:       "edee00a91f5299b488bf240492c7603b6dc1ddb2bc0f34737c0fdcce48723343"
    sha256 x86_64_linux:   "436f89c4a102f729f972233f0f0284a28d350984990700c0a5728301c1ddd476"
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
