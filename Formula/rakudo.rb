class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2022.02/rakudo-2022.02.tar.gz"
  sha256 "6a6e9dbcc6d9a1610a34c6ec67e2d3f694d7b33e9e0a0f224543089fa7f71332"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_monterey: "1dbfaff55ea5463638fb5799c7c924ba6f4e8624eb5ff96475b6a4495e2f1111"
    sha256 arm64_big_sur:  "5ae84dd92d1bf61d927e7f37147e3f8bf62b0a1e7813c1043feeefef565a98ca"
    sha256 monterey:       "fefd5708734b27f37ece96736c58c22942ebd9ee0f45531dd938db686edcab64"
    sha256 big_sur:        "7c17b5ce2de5a8c18dc94ff51b6109927daab34a9ee061571a373e0d7d9c5a9f"
    sha256 catalina:       "ab0e3765530b95c1481e38cbcb38ad81782c102e7978da0aafec7a5d173732dc"
    sha256 x86_64_linux:   "696a648ee7cb6756c871f9372ac92b737f145c5594fed05790994d8d45034f02"
  end

  depends_on "nqp"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.p6" => "perl6-install-dist"
  end

  test do
    out = shell_output("#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
