class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://rakudo.perl6.org/downloads/rakudo/rakudo-2018.12.tar.gz"
  sha256 "67bb02b9afd4f2a2a8542e25ce2691bc2d77864668f0fc82e1d39dea31a584fa"

  bottle do
    sha256 "ff76c570e4ee24d0fe5f3cee06994e9acaeb6b6398bca06efab140e7135aeb1a" => :mojave
    sha256 "17a8570054d279c922068afe4772062f4b47977203b101ee180c3b6908b9115c" => :high_sierra
    sha256 "fd71fce5030a6b05098d1918306f8cf40f286fe5e98b4f57b2e0f22585bf2ee2" => :sierra
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
