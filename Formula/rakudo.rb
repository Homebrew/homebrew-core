class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.07/rakudo-2020.07.tar.gz"
  sha256 "39624de1394b3e15bba0b456afb598fb2c47c3f38528ba375bed583213f0cab8"
  license "Artistic-2.0"

  bottle do
    sha256 "c9a8bc102ab08a52d0c4a71283125a0773cc9006ea38ceaf79a6ea33da1376cd" => :catalina
    sha256 "78807f1deab1de738c745df0721201ff3fca324940777ae217f77d695cfd6f68" => :mojave
    sha256 "365d8bda3b010915f05efa18f5b11f4af09f36d754a625078d3a2eb37d839b31" => :high_sierra
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
