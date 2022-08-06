class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2022.07/rakudo-2022.07.tar.gz"
  sha256 "7a3bc9d654e1d2792a055b4faf116ef36d141f6b6adde7aa70317705f26090ad"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "bcb4a1aa20bd3fbb3897ee9aaf4492a1a8985e4214060bcc902b29033851ee48"
    sha256 arm64_big_sur:  "7e4b2e0e000be7675d58ec6e87def4430804a64eb90f3047b0781e5d08f1f720"
    sha256 monterey:       "2f9a945ab154c1abb995f426307f259f5243fca8537a6c22b50097ac9339a007"
    sha256 big_sur:        "b3b36ad5f3b3ca9f8c0897bee40171a9eee6c0bb2c6aa1a9cb51397695ce99c2"
    sha256 catalina:       "2d598a9c1eb95f2a68fe13ad98ce5aa476244d4d096f45a60434222f0d112dc6"
    sha256 x86_64_linux:   "a31955817038c274cd2cf4677a80d1f5a5018e4b4f727007771f9ee7c9df6ba6"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "nqp"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
