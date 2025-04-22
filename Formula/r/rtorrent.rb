class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.15.2/rtorrent-0.15.2.tar.gz"
  sha256 "d10fd7d392d5d1e599ccf54238270df8b14b03fcc7cb8f62778ab868af6b0e5d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "11720ba689fdd79e6a177178ec3bbef77e833d1ab4e600cfb156b66a060bd970"
    sha256 cellar: :any,                 arm64_sonoma:  "bc80be52d57d714e7cc017c00549bbca8b10a2da941c96ddae1a6c311127bf39"
    sha256 cellar: :any,                 arm64_ventura: "3548776f98f105d49205bed94e33189be0ecc5a23cac650194589d2a159d0575"
    sha256 cellar: :any,                 sonoma:        "bed123a0a50f770f8961f8dd30ddd518eab6fe17e8d2a1290950e07642cbd95a"
    sha256 cellar: :any,                 ventura:       "1f96a7c21fae6de369f5541e9ab36e0026bfd9794d873762bf528d56f6abedf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "defa9448fbf9dbbdc9b3b24991a0277bab2f9e6601d3dbc8c5a1270f8a1f5d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "506a450f77c82f753fc3842ba9c384201a688cc9e82b14536312516bfbe76244"
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
