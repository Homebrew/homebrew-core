class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.06/rakudo-2020.06.tar.gz"
  sha256 "4cd8fe8afae3a2b561544c8e0dad5b4bc6cabbbfc2fdd17c63f5ea39dd46721a"

  bottle do
    sha256 "3fd37f96d4819ede87e4a104c940a9b275f6afe56185004cdc602c96afdbce91" => :catalina
    sha256 "6eca8c6adaf5acf45ad95ec3647c08e98170480468272d8c50c6818639e55a6f" => :mojave
    sha256 "c084e199cb8d766a7f24cf00e2488e1fff604a5c6a7839fa9fceb48011802a03" => :high_sierra
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
