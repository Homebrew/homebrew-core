class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.20/rtorrent-0.16.20.tar.gz"
  sha256 "8ed301997f1759c5ecfff205616ba36127cba47ab2b5b5aced4db48a11fa6a74"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9e7150c9b0c8ff6c8a8e0630343498f1138ddf0e170d2639a39b79f62a3011b"
    sha256 cellar: :any, arm64_sequoia: "99ea1ff23831d839f81d8c72d5c6e5cef0b5f976b1db7928bac87f949d4f9522"
    sha256 cellar: :any, arm64_sonoma:  "b1204d8c9f33c5dd7942cca8e44c53d6e74146a0a33a2e46805fb3de13f0a6d4"
    sha256 cellar: :any, sonoma:        "6b908bc3c031f03f9d9bf74a917813d719dfa10d5f4d6d7bb43a96f6702e716d"
    sha256 cellar: :any, arm64_linux:   "b8a5dd7ff92ba3fd06355bfb4061225cd241e9bd47293acb0b64470a5f9b47c1"
    sha256 cellar: :any, x86_64_linux:  "ddd276a21b43530f6a6e17276e39372efce925140f75c1efea3c1c348f042215"
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
