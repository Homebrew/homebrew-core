class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.8/rtorrent-0.16.8.tar.gz"
  sha256 "1040d14c909ffae51361805d03aa5d11fcfbc2df65daae5c09696d9e70853853"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "133e2b8cfea5b2561c24d5804f000ff92559f2e55100b2e50028e50d3a49d892"
    sha256 cellar: :any,                 arm64_sequoia: "04c89301842dcf5cbcbf5ca5e93b45ddc2d40743909184bb8b7e8a591aa3f0fb"
    sha256 cellar: :any,                 arm64_sonoma:  "5fc54c06eb5da6a20d0342f5f6f9ce11cea5e5b82f7c25477aa835957126b609"
    sha256 cellar: :any,                 sonoma:        "f624efd2b30dfc3aabe3843efadc9cd10a7b96cc0a02b20afa24e138d1aca6ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94b106fdbf20b3311ae406063367df20c96e6e594e5f66bc791681120b36f70a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c10d65c169a3046665446bd751dd071a79c68bf1035afcdff121bd68da7da2f"
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
