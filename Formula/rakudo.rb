class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.06/rakudo-2020.06.tar.gz"
  sha256 "4cd8fe8afae3a2b561544c8e0dad5b4bc6cabbbfc2fdd17c63f5ea39dd46721a"
  license "Artistic-2.0"

  bottle do
    sha256 "80870b47549bfbee7413bd31e6027c0f538e52572fa1cf0656371480d34016e7" => :catalina
    sha256 "973ee2b4de49403c823c1ed47793cbb0ff7114efee3e457876313c4486cc4999" => :mojave
    sha256 "d44bd6000cf8003aa86d001e374ed113f98b222469b7d421baa4e751f1bfe34e" => :high_sierra
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
