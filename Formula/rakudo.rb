class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.01/rakudo-2020.01.tar.gz"
  sha256 "2e02fcfca2f79ec6bd2dc0f0840ae108ec76f030f3080aa47f23f80f92b6c3b0"

  bottle do
    sha256 "e180ecda54bcd74f66f14850fcb733a9552fe0618e71cd7bf2576beeecd7866a" => :mojave
    sha256 "0d1bd679975d7621389aa48b9ad48926608d697d7130c7ec8b6c6aefb505f574" => :high_sierra
    sha256 "ea0966b945f85ef68eccfb42fc78551d92adeade9f0aec8bb70fbf992f3c34f6" => :sierra
  end

  depends_on "nqp"

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
