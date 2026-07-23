class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.18/rtorrent-0.16.18.tar.gz"
  sha256 "0c7d4902cc914fabe984284330333c7b82aec9951c55915712cdd10acaae65cb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "676857ea989a6939fdd8956d4297c7a14bbf19eaa164ea3b2cf416d2d8a28baf"
    sha256 cellar: :any, arm64_sequoia: "b20fee5fef886f5d0596c0283ab3fadf650f7ef1bfc90fa20fc1bec3dbf2e696"
    sha256 cellar: :any, arm64_sonoma:  "a3470579ca0494c1c94d90879d04640e4f0bb664f80c450dccdb1b7bb5df3c1b"
    sha256 cellar: :any, sonoma:        "9aa78274db49eabdee4519f4472f1ae835f62adcdb2bd27fb18ae19463a9ca09"
    sha256 cellar: :any, arm64_linux:   "765d18094ac79c0fecffccfd7396272d5b55d4558dc057fdff2ca1ecfb369f87"
    sha256 cellar: :any, x86_64_linux:  "ba293727f2e8b08b310529fde7949af6dc525ad0fc9c8bf6db7dee119ed65c77"
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
