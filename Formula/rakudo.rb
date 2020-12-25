class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2020.12/rakudo-2020.12.tar.gz"
  sha256 "c7ccfbb832b97607282d2cd4747e68522e522fe254e329a869053145218f6cbc"
  license "Artistic-2.0"

  bottle do
    sha256 "253d75bc98442185aa8fad9ac5d4097c24576935e977b03e573f4145845d9e4d" => :big_sur
    sha256 "728878342bf1dd81910a48cd05c20148c3fa7da6722c80a437abf3b673acddf5" => :catalina
    sha256 "c0b8951aff0f024a5d2495736d0d77cc4c41a09744953fe025db9bd36c05bacf" => :mojave
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
