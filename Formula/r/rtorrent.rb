class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.15/rtorrent-0.16.15.tar.gz"
  sha256 "202b56b75916cae86b4db4208cc42279f12d07a06e2ffba8ac8361bcb6dac18d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c8c1b11d4e74c183d6de891e0cb2f2a2378b59466f24fa5d89c9d2fe218281f9"
    sha256 cellar: :any, arm64_sequoia: "4709ebf33982018a92e99bc20d3d9151697e90c2821a7ceea96c19d722766c65"
    sha256 cellar: :any, arm64_sonoma:  "fa0c30ed0320e4fa4f078f74896e062de7faebd4fcf4dc9165879f1e626a21c7"
    sha256 cellar: :any, sonoma:        "ce2c86e2fe225a4898d6950d6a810d633733bb134e8db2adf1871df5b8abbb19"
    sha256 cellar: :any, arm64_linux:   "b4e2f006281ac447175016e172e2e624188de475900e8b0518afa8c14e4cb95f"
    sha256 cellar: :any, x86_64_linux:  "f0e5a3c715a40d6b9e30eeb41a75c12ec72e886a189812f4e6bed6161dee9fca"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-xmlrpc-c", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    pid = spawn bin/"rtorrent", "-n", "-s", testpath
    sleep 10
    assert_path_exists testpath/"rtorrent.lock"
  ensure
    Process.kill("HUP", pid)
  end
end
