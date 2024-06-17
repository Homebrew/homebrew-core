class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2024.05/rakudo-star-2024.05.tar.gz"
  sha256 "80a7f6af8439d8cac90b9ca11db01a137e964fcac8cd6cdfc5f1256fae7cca6b"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "6103acbac1454ca1680ced94e35d2399d976f3f47dd81bbbc9ab0ec6ffee0b5c"
    sha256 arm64_ventura:  "3738ed6f8c732ae78019eadaada3df7b69aa21b424d2a62d3551f64c75194240"
    sha256 arm64_monterey: "d3cd2aad7a14baba2efd658bda93a079189e9f00b2bbe7329f8086bba5d07884"
    sha256 sonoma:         "7bc287f4e415ca1994a27b6cc60b6711cd8803feb01165fc0f42f8862b9de392"
    sha256 ventura:        "b829ac4cec0bb86d839942be7b4e4f0d124dce10aa2e0cb75099a86abcef20a5"
    sha256 monterey:       "8256c09ed49cc837c0b114dd66209e0ff0961c0afa9cda88245f8a035d98b822"
    sha256 x86_64_linux:   "b081b0a64ca065c293ba25c2186784b14a96ede8838caa5d66713411f6e4ddc7"
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
