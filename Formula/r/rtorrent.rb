class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.13/rtorrent-0.16.13.tar.gz"
  sha256 "fbc800582974733bae5b785561780e38364e4659e9bb8abe8b2bc0a1e0d96e19"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6391f486a57b139e4893781862058995efb889ec55aee24086fcfa511872dfdc"
    sha256 cellar: :any, arm64_sequoia: "e0df93315d11075bf1a48a6f604658a0925d9f5dbc0ac87b9eacd4ffee6b7d22"
    sha256 cellar: :any, arm64_sonoma:  "f37d16ed1514168c971a9e1e6019ff7e0af16b8b221a3b994d5ebaac71602d33"
    sha256 cellar: :any, sonoma:        "7ac4df6b36710d116eb5d3ce502898aa6d4fdca1b83c428c246172327223d3b1"
    sha256 cellar: :any, arm64_linux:   "93703414daf356c8868fc605067ca120fb8933694a40e52d2216e2cb79fd25e4"
    sha256 cellar: :any, x86_64_linux:  "a328b9f0b89f2dca4fbda802f6918c009ecfbd1bf25eace08ebcd9b8f789f7a9"
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
