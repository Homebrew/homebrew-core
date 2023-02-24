class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2023.02/rakudo-star-2023.02.tar.gz"
  sha256 "330b8c8bbdf2dbed5924014b0b8df5202b8e0460258de0afe7f788af4aca5cc6"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_ventura:  "952340ee190ccd8f2ea70496200586381bc27f67502b1f9078ecd091068ec72c"
    sha256 arm64_monterey: "9b70e0f7c91465d0a45cbd933846c5ae34fdd14ba80678403d1a7b86a93f5515"
    sha256 arm64_big_sur:  "8b0b6c1ffc5bd1644b1aac4a65bfe345a9f81d7081d3fd95d16bc595a613ef19"
    sha256 ventura:        "2afdf467451f0146ed7e5492334f848dda6d535abf2347d6ee5ab8ed2ebe8a66"
    sha256 monterey:       "dccc08cfe6a9b460c74880d613150011b421dcdf61614df144c631aefc46a54e"
    sha256 big_sur:        "e23f744f43c547f1b3144e42557f32c0da327f155f39ec45e8bc0967dcd4ca34"
    sha256 x86_64_linux:   "1ec9d629a5fd958f20a5200648ea2a9c252abd413225459513a4f5e088b7f3de"
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
