class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2022.02/rakudo-2022.02.tar.gz"
  sha256 "6a6e9dbcc6d9a1610a34c6ec67e2d3f694d7b33e9e0a0f224543089fa7f71332"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_monterey: "d6bcf0a4b6241126ce1ad92b31db45bb2cf369f02ee5d01270b25630ba9a49cf"
    sha256 arm64_big_sur:  "5d72bbc60d07c5293d3bb501d1fb7545dbc7a6062b9b14b7ba1970bfe8c29a3d"
    sha256 monterey:       "cc6fa15bbbd34301192fa1a704e82b73c754c470d465118e1fade02990e8cbd9"
    sha256 big_sur:        "6af9ca3fd8c12616229fa2b0182bb1daeffb3911eceb003c8e9a6a4626fc0740"
    sha256 catalina:       "12ff83a06c6f87b7f12cd69117f05e52fff92e0935b5ea1cab3c6abb190d939c"
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
