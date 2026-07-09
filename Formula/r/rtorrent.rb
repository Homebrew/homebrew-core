class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.17/rtorrent-0.16.17.tar.gz"
  sha256 "115cdb6bf70f5c0f43687ca57c974bc45a7ff970562a56b51b971b9bf51ef0a1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9d6678787badcfd0647eca3517daee87d83f174f6de8a77b3bca2ff5bd462b40"
    sha256 cellar: :any, arm64_sequoia: "06046932d798170e03535761710e2da944e01cf8dcd5ea29817b443382ad0769"
    sha256 cellar: :any, arm64_sonoma:  "e5519aadc4b93714c157092bf968cfd5332e6e1a16fc2d7593ae7eb0cfa40828"
    sha256 cellar: :any, sonoma:        "ebc99195391cae7757dad8b01eff7cd9dc8b1791f409fd481c4e566a4b111c03"
    sha256 cellar: :any, arm64_linux:   "bbda13baea8271b90a4183b2bea1789a0e63d74f97575ba527a65f361df1bd54"
    sha256 cellar: :any, x86_64_linux:  "15d6aa8969dc4a87785d95aaafa91199761afa57a62b3441fac58853ce7e9cd9"
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
