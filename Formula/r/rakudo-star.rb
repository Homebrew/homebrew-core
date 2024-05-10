class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2024.04/rakudo-star-2024.04.tar.gz"
  sha256 "49bc2f8461e2b194ed2b8800d83f1de27e216b46404b96abd46df82678814c86"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "6e3c6d33c9f595f73945ed754ee963ea32eb24562a1ac3065d73206cbad389e0"
    sha256 arm64_ventura:  "00222a1c451957b1cbdcd8664aa05a18d2cb3579246aeff12057cab9b65f6620"
    sha256 arm64_monterey: "364d79efc2242a21fa5e06506651b7017d2d19a1a97ce5e9d1c7eeb34e6bb380"
    sha256 sonoma:         "fc005ff536122020d9aa90c5bd7dcf99cc8f84d54d12862d685f2b7bcaca4f74"
    sha256 ventura:        "513ab9bfe79e5eaf1361f32446e407188ecb53a5ca414b13bb8c19a032fd3598"
    sha256 monterey:       "cbf3eaf48fd50ede28b048e075f169636bc21fad67890464db8e9d1056e92515"
    sha256 x86_64_linux:   "04f6b0ac58b15d255c6a8c02e14edf86f7105ce72ae5ae4a1d79bd16166af111"
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
