class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.11/rtorrent-0.16.11.tar.gz"
  sha256 "bed2fefd69a01dbe95a02b330dd8c257d1aae2b4ee2ba4a9c4859da2fa404f65"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64bda771e0c7133a176cfc11f57d740067093ae167a2fe544d4607a3432b96c9"
    sha256 cellar: :any,                 arm64_sequoia: "4855fcbce61ea73d2ee761c2446c56f45a5e4486401c693fde19efbf02e891b3"
    sha256 cellar: :any,                 arm64_sonoma:  "1ee5afcf3717a87b8e7bcf704f851a74d564a0ecb32e593f94b5c5fe237cf277"
    sha256 cellar: :any,                 sonoma:        "d959275ef4091a55d902a1f7e4557389d6a389d72642dfd6899aa02fb948e04d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "371d799657d5b4645ab36212f5d8939e21d5c1139c58fa4fb767dab5ac82057b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd30e10b9924c01888804f41299a6a4c21a643a3991fd240921af7ad24af1797"
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
