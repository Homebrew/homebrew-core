class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.6/rtorrent-0.16.6.tar.gz"
  sha256 "94e8408a20332cedea45a4b5f09c69f0f0c54581e1b02e1d7f61f46fee3c41f2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "256aabe0a7018e1fb00a457c8a3195e6912180eaff2737b760b7a6b3d2b3a1b7"
    sha256 cellar: :any,                 arm64_sequoia: "77c8efaff4d31c57dee58509caa408cc48dd3b848a13bb0ccc07d99ad502e7f6"
    sha256 cellar: :any,                 arm64_sonoma:  "dfdf509747ff9e5608382ab6cf87e0e7b7119ca191c7df6c758fa46c143e749d"
    sha256 cellar: :any,                 sonoma:        "c30a5fd3e04cc54c1413f4718234dae0e4a967cbda0f048c419ace70ed6da8ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d48dc3cfa9dd09b00a0c3fd48a578e9272513db3108e5bd0ead9932e50260fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2022e6c4e8d22139a019b7007dce07d6b9105e5f6f81862ddd959e8196df3e"
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
