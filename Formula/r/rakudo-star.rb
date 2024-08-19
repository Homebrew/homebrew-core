class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2024.07/rakudo-star-2024.07.tar.gz"
  sha256 "ba2f4869dc99b55a8dcfbac9e7420955097ef426be0f72e56bf8f006911a8a8f"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "7b4f81c585a74cb2dd53b66f78de071f843174e927a5bd09de8eef6ba3102575"
    sha256 arm64_ventura:  "121c9b02ee9e34126e4256c6751b60a98fc653dd7f057023ee4496a9133c2541"
    sha256 arm64_monterey: "930d4e76a2b97a975900e5e1af2daba77f2daaf48718ec5cafb5759ab5b30664"
    sha256 sonoma:         "dfa7b6cf2fb13462ad7e53803acbdeddcc83c7e73e7812e9f7050325411f8af3"
    sha256 ventura:        "a2df25542d0ca221eda42e4982370905cce993e5b8014b4e01d6ba9d6863be77"
    sha256 monterey:       "f448c7dee91af27a88cd589c6a65e9dd1f4188560ffdccc86b33ab6c3f9920ef"
    sha256 x86_64_linux:   "15c9d231183307647e2ce8ea885097c34d54cf3fb1dc481a37e013e34a7b3801"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c"
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
