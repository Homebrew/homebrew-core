class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "https://rakudo.org/"
  url "https://rakudo.org/dl/star/rakudo-star-2020.01.tar.gz"
  sha256 "f1696577670d4ff5b464e572b1b0b8c390e6571e1fb8471cbf369fa39712c668"
  revision 1

  bottle do
    sha256 "62c80b5c001ffede84e442a8b0f8cb8526e2b8ee2e5b15b6637d7c39c8164d04" => :catalina
    sha256 "b338c7b0d69b5c058d8e8b826b36afb12c5452ee1b2a1b727cdcbca50015068a" => :mojave
    sha256 "af8a220b91c21a5ce55d92a8015c81f575f257bee8e5b5a6877edc5b3f352f4b" => :high_sierra
  end

  depends_on "gmp"
  depends_on "icu4c"
  depends_on "libffi"
  depends_on "pcre"

  conflicts_with "moarvm", "nqp", :because => "rakudo-star currently ships with moarvm and nqp included"
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
