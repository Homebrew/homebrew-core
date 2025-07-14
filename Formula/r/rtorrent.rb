class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.15.5/rtorrent-0.15.5.tar.gz"
  sha256 "847a3fdb69188c621950a3a74eaf8dbc464118659c9638d10c7cf5df57508b17"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2fbedafd9b8ea6967606c71ecd7d3287ffc538377f0a961d487b27bfa8a4e8cc"
    sha256 cellar: :any,                 arm64_sonoma:  "a11c7ffe9cb63552cc4fbb28daa7791d60e30fe80366294dee8738c5c25afae6"
    sha256 cellar: :any,                 arm64_ventura: "e1737b4bf3ef0889e2d966da6e1e75be865b919b683a5c56ce4d02ac9bc5a986"
    sha256 cellar: :any,                 sonoma:        "6d171127df1bea0a391b3a4a586eca3bee4ffe8e42f82a7ec88e565090012dba"
    sha256 cellar: :any,                 ventura:       "5679b89a2f0923d8b356d9fafa59ad2e761e0ee2044bcf0a3615fdd3033ec008"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1be0dbd4486293935fb0f15418354c347ba5c98ebbf5ee0db6075f27a362ecfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b94d041e74fc24ef09ed45480578b75824c0572672dad8d081f0f767a9fac124"
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
