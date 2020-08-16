class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://rakudo.org/dl/star/rakudo-star-2020.01.tar.gz"
  sha256 "f1696577670d4ff5b464e572b1b0b8c390e6571e1fb8471cbf369fa39712c668"
  license "Artistic-2.0"
  revision 1

  bottle do
    sha256 "3a2d22c17772726872aefb5afbf216f6640c0bcb441c98a9e27aab73b0edaeff" => :catalina
    sha256 "b53dab6ef44c73ea480ce74577a6b4f1593e124d2e5e502d3e134a6e81d7c054" => :mojave
    sha256 "e4ecc1142965f84eb7197d8388390d8968f5e7505628bed3b8e2c41a98c324f7" => :high_sierra
  end

  depends_on "gmp"
  depends_on "icu4c"
  depends_on "libffi"
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

    system "perl", "Configure.pl", "--prefix=#{prefix}",
                   "--backends=moar", "--gen-moar"
    system "make"
    # make install runs tests that can hang on sierra
    # set this variable to skip those tests
    ENV["NO_NETWORK_TESTING"] = "1"
    system "make", "install"

    # Panda is now in share/perl6/site/bin, so we need to symlink it too.
    bin.install_symlink Dir[share/"perl6/site/bin/*"]

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    mv "#{prefix}/man", share if File.directory?("#{prefix}/man")
  end

  test do
    out = `#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
