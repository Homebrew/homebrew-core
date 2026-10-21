class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.25/rtorrent-0.16.25.tar.gz"
  sha256 "d9c17e0fae59f0cb7533966f3ed778e9df701ad84d5dd50e9bae2aefe0f00a2a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ffd8ceb759a688d00de9e5d5f42c9927c22a6c6bf5391aece11ad36d70579acc"
    sha256 cellar: :any, arm64_tahoe:       "2aff71753a656fb8aae8c03721106619110b18b678140b8ace6eb2c3c8a17593"
    sha256 cellar: :any, arm64_sequoia:     "720f057e7b8770186337419e088a9af87cab5e777d1b89a4f8a07be9ab957c08"
    sha256 cellar: :any, arm64_linux:       "ce83d956387ae3939123f18e42fa8b665052d45a35185911565f4aa69cff86ea"
    sha256 cellar: :any, x86_64_linux:      "38f2e92fd988eefa615e2e3968ee39bdd149bf3baeedfbf76f83c052e95e9d7b"
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
