class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2020.10/rakudo-2020.10.tar.gz"
  sha256 "b62503ef19e23f6b44266b836a0ead65355c477a19b90408682ca27fab8d7a73"
  license "Artistic-2.0"

  bottle do
    sha256 "955154866a3c4594c5e25eecfdb5616b1c575afcd46a38171ef9560edecc14d4" => :catalina
    sha256 "6b9473bc84f70846cedfa28c05bb01555b090cd61bb657507eb2ff37969b6187" => :mojave
    sha256 "f72348cf24d1928449d3550d2ec9b14380fab52171a53ce20a44fa086d25ebff" => :high_sierra
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
