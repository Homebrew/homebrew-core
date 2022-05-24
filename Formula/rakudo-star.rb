class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2022.02/rakudo-star-2022.02.tar.gz"
  sha256 "49a2f9d440ffd443e59bf52b414220e4186b28c27a1984331d207d4c0e9b0968"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_monterey: "c9b64b922ecd90d9fdf216957f1f4eac36550e72c0c8bf8ad734a40d9f36fe67"
    sha256 arm64_big_sur:  "7bd7f7d2530c7daabbcc92eab0b2bef5a12e87081e292d2c677c26b498d6279e"
    sha256 monterey:       "1c89d13394cb956e2f84601aca508be1e172862da4dcd5e9328684935beddb7c"
    sha256 big_sur:        "7bcae40d6e519d5eeb262d7fbe680612fd3e1d8c83e1bd44d9f1f2e949c85e7c"
    sha256 catalina:       "7627c1c3b28e9fe804792535ae1e637c5950401285a97a5fc1fd118724f05d77"
    sha256 x86_64_linux:   "65b324dd0afd9213b9ba82c229b9c8edeecd28ec0092d0c48da72e36f57d3185"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "libffi"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline"

  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

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
    bin.install_symlink Dir[share/"perl6/vendor/bin/*"]
    bin.install_symlink Dir[share/"perl6/site/bin/*"]

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    mv "#{prefix}/man", share if File.directory?("#{prefix}/man")
  end

  test do
    out = `#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
