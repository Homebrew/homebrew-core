class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.15.3/rtorrent-0.15.3.tar.gz"
  sha256 "6dfd42c19e6ff2f5ee8b99855314cef4f10bd669663c2670cc85fd6a4e2c4e40"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7abb3f0ac2b614f55c1f55cf4f624137b6532c45e900fa534da392fadac5846f"
    sha256 cellar: :any,                 arm64_sonoma:  "7d2c15dd128af1b7403126bbeaf63d0628f579a8eddee6688b51a91b18e4a5b9"
    sha256 cellar: :any,                 arm64_ventura: "e7d9c5a9ba6291a6043aba2a146f37a361afc3382e6a65a8948ee2fa366ae1f3"
    sha256 cellar: :any,                 sonoma:        "791e577e539051b785bf7fcd8f02acf6ebaabceec911227204abf027a7ce9620"
    sha256 cellar: :any,                 ventura:       "789d7e46ad1019063b7bd7ba94011bc4c56e17ae8fb15c0dc862765dec2bc955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af91d9a66c6d6fcdcbfa44d6489ecd98a2342a7756bdfa8e7334c33e6ede2a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acfc175eccfc821a19f64f05a13d92f31311dbb35691f490af727178ad8f0461"
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
