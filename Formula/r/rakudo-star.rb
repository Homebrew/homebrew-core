class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2023.12/rakudo-star-2023.12.tar.gz"
  sha256 "defb8d96ba80cbdca7af071c04720ff3d6e27400dc8b28acd2450d9b1bcc4e97"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "04b924153872afa7864342dc00091677b9ba5ca6d49245b81e4f724c342a6cf1"
    sha256 arm64_ventura:  "0fe85cbedaaa4c343e0dadef9dc36290d94610e04e92ee295ff7891132e578c9"
    sha256 arm64_monterey: "b62ac3a589c76685f33f7defa0dad2501bb77193e2b0e718ff805dcaa388820f"
    sha256 sonoma:         "2a49c4eccb1489cfe426aafdd3f8d3c0eb8f0d0afc6faecbe1322f3f8b001519"
    sha256 ventura:        "cd0d4ca2e0b4c3f846abf1b83db493f02ef4a6e70aeb676941a4205a1164d29c"
    sha256 monterey:       "4a6aa4b0c7b01eeb1f44b2e3823c61feaa1c40569f0d103ac4306ad086b474de"
    sha256 x86_64_linux:   "7c6c20610691a9b88ebe4c300266776a409feda7f517231c0225219fb6b751c7"
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
