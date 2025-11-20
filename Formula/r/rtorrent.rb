class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.2/rtorrent-0.16.2.tar.gz"
  sha256 "248da813b3b6ff89016b5e11c59e6820857f5fb01dd4aad21843e5a461877cff"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9137d585b9722836fc811ef66d4a2e4b70cd61657f0091a4360f43bf7c0954d9"
    sha256 cellar: :any,                 arm64_sequoia: "7a2ccf20417943fa22fba566caa41f3e8578500ca7a9329ad8f2c0d456ed3224"
    sha256 cellar: :any,                 arm64_sonoma:  "782af8f77f3e614f3a42719c2e4f0b30457e7d10e47f8065c3e8c4f45f73b933"
    sha256 cellar: :any,                 sonoma:        "a6934d4c6e3556b7f58bed45f92027c704dcfb4f7e67736f86974c1cce5e8273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ee5ecf20d9745e21da7fc27e53b0017bd9eaa13d17190730a0102b9c2419e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f05868f5df53ab1e6f6d1e7abfb5e3ab2852c2ec9880f728a397251310f61dbb"
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
