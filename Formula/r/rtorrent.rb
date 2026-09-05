class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.22/rtorrent-0.16.22.tar.gz"
  sha256 "4b157f83d93fd6fd3741a018a7397485dec5c080cbf222b336749b7d5f8f63d6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9434d6a330a5d6278f6fac82b1ec3399bba44ca0c99ce3068cc2e45dc6f999ed"
    sha256 cellar: :any, arm64_sequoia: "1c2df5bbd2dad55f1d7476460631533323c3f55241f4328f1d425c7848e1698a"
    sha256 cellar: :any, arm64_sonoma:  "826f8674034b7ff1d248521012c964ca72111f4495f1f44b9542bca0824b5cf0"
    sha256 cellar: :any, arm64_linux:   "fff496c38480197bb47af1f5550804edcd9b109e32a080641225e3ada0b904b0"
    sha256 cellar: :any, x86_64_linux:  "81209ba0c8430d3d3bb45bfb7fa99767f2be1c7e030134d3bdac3364f11d1867"
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
