class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.23/rtorrent-0.16.23.tar.gz"
  sha256 "be8679cdc14be9bfe7044e09d50c822a85805ca79554436464822cd34a11798a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "79cfe08feaff62b342aec726185a35adece9b3d5e34b032954e3d07e77148bba"
    sha256 cellar: :any, arm64_tahoe:       "13c7f8c87ff2262252b0c18c8e624113b6dac9049a08dca66736da53c23de453"
    sha256 cellar: :any, arm64_sequoia:     "942ebf6b0425bebfabf3c889dadb3a6946ba1669fce1af6644af6e1f51fad881"
    sha256 cellar: :any, arm64_linux:       "3e25d5ecc50b75b9322e3483969d9b030b7535669dbd9e99b9bd2a9410fcacf7"
    sha256 cellar: :any, x86_64_linux:      "1b5d2d7b881aa3851f24b73c3ab52f9c85b7e587d2da0b6b516c00b9ddc6d899"
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
