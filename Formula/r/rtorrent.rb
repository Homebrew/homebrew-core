class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.15.1/rtorrent-0.15.1.tar.gz"
  sha256 "1d5437d7a6828f2f72a6c309f25f136eda1be69b059d250bc52e0d4185420506"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7fd8876fa905a4e5c0048075d04a061fb28147e727eecfd4b80ce994c96d885"
    sha256 cellar: :any,                 arm64_sonoma:  "a67c258fef8075692db56f63c63eada71a8fc5b66c513762953457f074530149"
    sha256 cellar: :any,                 arm64_ventura: "acc2ee7afe587f3ed97e379cd2ad238af586483d3783571d2a6fea90a2eaaf3d"
    sha256 cellar: :any,                 sonoma:        "48e01478a36cdcdff32d78a2effa418e00b3ce838cdb02b092bdd26729c873ef"
    sha256 cellar: :any,                 ventura:       "5f269d47486ddc79fe24ece2dff35cbe16abd3a3210dc899abd64c682b352fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2107b8aeefe50f463128299c7a26549f060c85e788dfdbd4b55020cb8f45f24a"
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
