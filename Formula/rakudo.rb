class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.01/rakudo-2020.01.tar.gz"
  sha256 "2e02fcfca2f79ec6bd2dc0f0840ae108ec76f030f3080aa47f23f80f92b6c3b0"

  bottle do
    sha256 "3bfa404b4001f30e06d1794ef03664443399f9d8e07c030cdf7f8aa5b1e61741" => :catalina
    sha256 "45becd098c8d4d1e7f2f800c07d94a996dd813e9af96c49db1e833f98780429e" => :mojave
    sha256 "c426e9201384e35d43371712e64ed07c4a04ec458c6ee8b2850f7f419bd49fb2" => :high_sierra
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
