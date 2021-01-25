class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.9.8/rtorrent-0.9.8.tar.gz"
  sha256 "9edf0304bf142215d3bc85a0771446b6a72d0ad8218efbe184b41e4c9c7542af"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "871a1aa520a4a0e35b354a2b350bf5db25e6ddce1f700aa8a222a3993872b124" => :big_sur
    sha256 "8f52ee42bb5991c719be574ecc13975e0ff8ffd3adea9011aaae89944a90c893" => :arm64_big_sur
    sha256 "fb9d292ae3f773162316eac2516bcc12a5a63718d4638aa4ff08a7d57e8a853e" => :catalina
    sha256 "7bdf998faac16a4411e0f52ef906e09dff47507cef2b1218ac59b82d9298ae72" => :mojave
    sha256 "ac0c6f9edd1fc875266e08a9d7576251d8be88f86162e5a431b10a5c5bb5f0b0" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    args = ["--prefix=#{prefix}", "--with-xmlrpc-c",
            "--disable-debug", "--disable-dependency-tracking"]

    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/rtorrent", "-n", "-s", testpath
    end
    sleep 3
    assert_predicate testpath/"rtorrent.lock", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
