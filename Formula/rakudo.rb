class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2021.09/rakudo-2021.09.tar.gz"
  sha256 "eec9a084e036b76fa4f9c68e9ccebf819fd13aafdc356892f0560eed1e8cf425"
  license "Artistic-2.0"
  revision 1

  bottle do
    sha256 arm64_big_sur: "e8106f54cabef24a42f96bcd8caeeab7e394d40601695430fb3e090524334288"
    sha256 big_sur:       "3cbd0401d0e26e69cea32379eb9f41c38924d157d0f85a4ebf7d3a149e916244"
    sha256 catalina:      "7219a7ab1b4ab2679c69cdf8d6f2d27ff1f7b931c6fd1c8f32d1d66033023ffb"
    sha256 mojave:        "6ed9b471f9c8b991ba8f33130a754212a914c87b55bf9e287e17049936cc76e3"
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
