class Qbittorrent < Formula
  desc "Qt based free and reliable P2P Bittorrent client"
  homepage "http://www.qbittorrent.org"
  url "https://github.com/qbittorrent/qBittorrent/archive/release-3.3.4.tar.gz"
  sha256 "c822e938e36fc5956476f9a8f52beecf35d65df2ba502c671fa3e90f7d0be81f"
  head "https://github.com/qbittorrent/qBittorrent.git"

  depends_on "pkg-config" => :build
  depends_on "libtorrent-rasterbar" => :build
  depends_on "qt5" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-qt-dbus"
    system "make"
    system "macdeployqt", "src/qBittorrent.app"
    prefix.install "src/qBittorrent.app"
  end

  test do
    system "#{prefix}/qBittorrent.app/Contents/MacOS/qbittorrent", "-v"
  end
end
