class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.28/rtorrent-0.16.28.tar.gz"
  sha256 "5b668c625c45fb452018c27480e1a01ccbc33d850cb109209966651dabec207a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "37ab375811bb9951ea03ed8caf8a81577333bbd216675ae05e6938f85f3a432e"
    sha256 cellar: :any, arm64_tahoe:       "39cce03ad16598087c7cbd7a759f93b3c2865eb5e33a5d95673d131bf88d9493"
    sha256 cellar: :any, arm64_sequoia:     "d552ac4925d6d4d6d4c8624772b21f13f7d108ad43a2238544a0d1d40b429b6c"
    sha256 cellar: :any, arm64_linux:       "e8cbe9c8fee7ac4abb8fe1027cd9cdb21cf46d6bb7eb02a0d504dc3c27694066"
    sha256 cellar: :any, x86_64_linux:      "6693bab8545009bacab80e9824a74f25620f85867453007002b9cb14d080344d"
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
