class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.3/rtorrent-0.16.3.tar.gz"
  sha256 "8d577ccbd3d7cab0071960ef341ce64c3214a7b1c3c07bc39077ce85ba9797c7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "daa444c56891ad5918376d753f6d05e3f7a7fd202682aca934b36d7cd76cd800"
    sha256 cellar: :any,                 arm64_sequoia: "f3042923fcf9e1f9a20ada2ca8563c8437fb76be80dd5bd8e8d3531884eebee0"
    sha256 cellar: :any,                 arm64_sonoma:  "46ba6d4d7e6622ec9665b54a3e4e5d3bd81999952ed1d36945adabe4d35fcc6b"
    sha256 cellar: :any,                 sonoma:        "4774d7b7e7b3c299b0da471a67dec01a7ab010534f6016b3890245e77b2c9667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75bff7674fd9c5818d8e6e6a27ee4fafdb3cdec28854791bc583b3077205d1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dc8e47fe723402996d4f8e49f2ccf9ae35ed466dc889feadb41320778f7c02b"
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
