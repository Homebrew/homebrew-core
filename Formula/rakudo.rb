class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2020.12/rakudo-2020.12.tar.gz"
  sha256 "c7ccfbb832b97607282d2cd4747e68522e522fe254e329a869053145218f6cbc"
  license "Artistic-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 "5190114f8e5e931e70ddc4f6d64c440b56d7d10fdc73f33ed7fd0ae92543fb0f" => :big_sur
    sha256 "97bff15fee0668ac35b311cb4f618741ded06333c64bd88a48bc350165124c27" => :arm64_big_sur
    sha256 "ed46d6a7fd0fb78780a70a89c46b00e59230ab2b11bfcaf4b5c3c95e281c6a5a" => :catalina
    sha256 "e603c62c7ad3dc1476d1730da109eaa4d701aac19d22355ae2c21173ee4a62e6" => :mojave
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
