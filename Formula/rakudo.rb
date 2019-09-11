class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2019.07.1/rakudo-2019.07.1.tar.gz"
  sha256 "d91dce95ec3f6fca1723c7eacfcbcc823269ba73dc945d778f608f0c878444f7"

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
