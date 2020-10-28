class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # Note: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2020.10/rakudo-2020.10.tar.gz"
  sha256 "b62503ef19e23f6b44266b836a0ead65355c477a19b90408682ca27fab8d7a73"
  license "Artistic-2.0"

  bottle do
    sha256 "f3f4f1a750130c0512c6e7bd7543a223d109e7a6f0f34352f56821ed8177e9d9" => :catalina
    sha256 "21e8a0fc99ceaa59441054001f14e4a08c18179361cd63674e7738b7a721b68c" => :mojave
    sha256 "b9174683a00886ad6c35b457109af18d7a43bd7285a378ff48598ce3be90a48c" => :high_sierra
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
