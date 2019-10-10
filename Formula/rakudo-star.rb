class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "https://rakudo.org/"
  url "https://rakudostar.com/files/star/rakudo-star-2019.03.tar.gz"
  sha256 "640a69de3a2b4f6c49e75a01040e8770de3650ea1d5bb61057e3dfa3c79cc008"

  bottle do
    sha256 "2dccbb7e92453c8c41cb3716344b52a9f620f434940fd583c6e9b0a6f20ce23d" => :catalina
    sha256 "0254663db2347c6002b4402ddbb7ed64bf29068b15e196e6fe011e9b027081ee" => :mojave
    sha256 "dd67fdfc69505bae6b7e1a30f5c6908bba312e3673ca81c415d3a626387ed8be" => :high_sierra
    sha256 "773b28e24f2893e23307c818b49f8517a6fb4a3af3be4eee468e4c2e1ff70555" => :sierra
  end

  depends_on "gmp"
  depends_on "icu4c"
  depends_on "libffi"
  depends_on "pcre"

  conflicts_with "parrot"

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
