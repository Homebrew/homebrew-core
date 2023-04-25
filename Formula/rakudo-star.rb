class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2023.04/rakudo-star-2023.04.tar.gz"
  sha256 "6f95cf320e533f184f58b33f7e2bfea8855f887666863ee834575445f171c153"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_ventura:  "d34e01f57a57356a3111d04e7026e74ec1a54080daf8d3da7b2f03bbcf30d015"
    sha256 arm64_monterey: "4228b6a3b40dd20966f2b12d46ef7392de22c7aa41463ef68a8c0e3adfc35023"
    sha256 arm64_big_sur:  "bff88b697ed44eedafe57ccf67424213b1cf00c8d39a793c2b310fbde29229ed"
    sha256 ventura:        "fa52c550e03af3a0652eaa114899d75d4ac08b4b464d6e68d8e766d9e91ad54e"
    sha256 monterey:       "7f981703f42cca549cd60e8a60d7ff9da0488d11183ff4285a908fcb37eceefa"
    sha256 big_sur:        "31bfdf6b7cc51feedd27f399ae2a81ff184f8bd117509c44625d17bd36acd7bb"
    sha256 x86_64_linux:   "304606bc1e6ab6c44aa3739b5852ad82a7ef12b23a1f1895f9876f4e045126b4"
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
