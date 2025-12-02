class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.4/rtorrent-0.16.4.tar.gz"
  sha256 "4fd458f025544c77eea63962a7866848bf06fb420a2b8cee12978b8e2d2add8f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0cc84d058b3651bc982c613ca18530c0ed8cd7a384591fd166219d056b4989f"
    sha256 cellar: :any,                 arm64_sequoia: "4d20732782a4b7382d60bce94f80d56e83d934805acc9593eff684e30d1e32b2"
    sha256 cellar: :any,                 arm64_sonoma:  "c984cf8958762085fc794b1aabca436c02b9f340df5ad8e5565aaba8cb7f4f53"
    sha256 cellar: :any,                 sonoma:        "358580c01246364f84c9cebbdea75f5651044897a25dd8dcc0568012c75b7e7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc95865fad018f81880d8f913299789273abe1ae4d3250756c6006429e590e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e636a42137177c55aee3bf3c0cb800102385d42c66e156bd751c38300d6044a8"
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
