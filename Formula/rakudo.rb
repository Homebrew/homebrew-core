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
    sha256 arm64_monterey: "9209114652da54019d080e0c1f2fb773ad95c4ac201a4ed74892a2eceb503bdd"
    sha256 arm64_big_sur:  "7ad8b2b69048b935e49f21257092ca3d9e2a72208fc6c28fdf1739403aacbc34"
    sha256 monterey:       "490c3585c6f88f113937b96b06037156ff5cbd697102ced69bb93230f85d4902"
    sha256 big_sur:        "4f1c1c5834ef59c5fca756fd3ec9fdc39cc30890a1addf010f232b38b74ff4b7"
    sha256 catalina:       "8a58e5439699eb059f898a6f732eb3a0b1514c06403fbca475f447b707a175be"
    sha256 x86_64_linux:   "3c67fcea8f4b4b3b8800d6c7379535206da9ae2e8810f1507a61a94fde205166"
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
