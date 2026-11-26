class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.29/rtorrent-0.16.29.tar.gz"
  sha256 "baaa11030634bae737659f0ba55b62cba19e9cb3da48654b45eb295e14ea5d51"
  license "GPL-2.0-or-later"

  bottle do
    manifest_sha256 "b9299331f917fdade446d415f79960590e7e15eed3c549cd616cee1670b312c9"
    sha256 cellar: :any, arm64_golden_gate: "2385f46d30a106320a0966052ec31ac12e1e38406a759d41648b3d057bdfe342"
    sha256 cellar: :any, arm64_tahoe:       "fa08c82e9f2f72f83454285969fe1ad26e62a0c69d9fac5bf049453334aa01b7"
    sha256 cellar: :any, arm64_sequoia:     "be0223267455593db28137065be332e712182c6296b0dd5caf772f2834a48325"
    sha256 cellar: :any, arm64_linux:       "1e8a25ae96811193748bb4de28a70e792c02b5cbd0176166a8183b8e1e675865"
    sha256 cellar: :any, x86_64_linux:      "1cb55150bcea908b71a4d808e6491edc1805d2b915769e2ad493287abe4c6b92"
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

  allow_network_access! :test

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
