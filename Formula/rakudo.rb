class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2019.07.1/rakudo-2019.07.1.tar.gz"
  sha256 "d91dce95ec3f6fca1723c7eacfcbcc823269ba73dc945d778f608f0c878444f7"

  bottle do
    sha256 "8253d87d783a646fed821e15b477f9d2059245deb3f400faa1bfcf437e39e0b5" => :mojave
    sha256 "391df8bb35448183d1fcfc1f10a2c5b7d613c6f8c8e33d24a99daadbb665b49a" => :high_sierra
    sha256 "8b27f3b79dbc03953a1695392d8b9c05eb3b8c5441d5e08e573cdfc102a8c5d9" => :sierra
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
