class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2022.04/rakudo-2022.04.tar.gz"
  sha256 "7e13a8cc927efbe86b8ff7b19155a60a6f6e2b6e2952bd690dcacef2d02a1c74"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_monterey: "bcb4a1aa20bd3fbb3897ee9aaf4492a1a8985e4214060bcc902b29033851ee48"
    sha256 arm64_big_sur:  "7e4b2e0e000be7675d58ec6e87def4430804a64eb90f3047b0781e5d08f1f720"
    sha256 monterey:       "2f9a945ab154c1abb995f426307f259f5243fca8537a6c22b50097ac9339a007"
    sha256 big_sur:        "b3b36ad5f3b3ca9f8c0897bee40171a9eee6c0bb2c6aa1a9cb51397695ce99c2"
    sha256 catalina:       "2d598a9c1eb95f2a68fe13ad98ce5aa476244d4d096f45a60434222f0d112dc6"
    sha256 x86_64_linux:   "a31955817038c274cd2cf4677a80d1f5a5018e4b4f727007771f9ee7c9df6ba6"
  end

  depends_on "nqp"

  uses_from_macos "perl" => :build

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
