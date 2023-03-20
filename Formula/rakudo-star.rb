class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2023.02/rakudo-star-2023.02.tar.gz"
  sha256 "330b8c8bbdf2dbed5924014b0b8df5202b8e0460258de0afe7f788af4aca5cc6"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_ventura:  "755aa15a4fb6fce9c476c776394d6bce3b5953b1bc3ef4273a73ca8ed29a35d9"
    sha256 arm64_monterey: "c365ab226883ca78d281c326b659933a614427868fb4f6e8b35cdb432c853c93"
    sha256 arm64_big_sur:  "dceedcf42e12a0fff39b0c599bedabb00815c944af61bf60d47bc9ccfa399c3d"
    sha256 ventura:        "bdc5d45322e3d6d361940761354126a0b580204f2d96e02a862a21e798ab5968"
    sha256 monterey:       "5b72c0a5ed40ce59471ce05eb9f3dc4bd254533a93d3c25990597863e584e3a3"
    sha256 big_sur:        "55549b1d505ec4dc087ef44cdb53a55bd5773190a513d485f7705585eda99cd9"
    sha256 x86_64_linux:   "4bc1c5601f48ff884c845a1f9b25f909fc758ddf69a4c64fd4ada3ed686cb70e"
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
