class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2022.04/rakudo-star-2022.04.tar.gz"
  sha256 "bb87464d8dcdfc457d4fd60488f22e4a6a7ec821d781b479f725aa3a635137c2"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_monterey: "8f2672c7e76d1ae11be18bec8f2c97e130170474755249cc53c65e2ec375dfca"
    sha256 arm64_big_sur:  "24f14fa90ffd79862c19d84ec9b1039365d3a65ccef6cdd5269de4fa008c944d"
    sha256 monterey:       "aa80c798963e43e47d29ff2567e8045fb35d81079ea9f3ac526557ce773a01ce"
    sha256 big_sur:        "a0ab788118f99615eb00758cb40abb9ac441d2d82367fefcd596c564ee20f53d"
    sha256 catalina:       "a14337712149b65a19f835e88ff838f65919b1cca963cc66d82f3ec122f9c64c"
    sha256 x86_64_linux:   "b9874b6a0a559c423d05d9830cf282363cb4babb4647d990fbe5c7292fb30cab"
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
