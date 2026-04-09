class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.9/rtorrent-0.16.9.tar.gz"
  sha256 "8eaadbc65ee80f195be170b0d12e5f3cce6e62bcfd69b80dc27a05898ff31237"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02fc5052cc589c3c3debb398f1c436032b1507ca0de5e807dd37633f28e97bf8"
    sha256 cellar: :any,                 arm64_sequoia: "da45f11ca9747a467a2d1ffc46a55f6ca883efe5d5c158b5ab01356498a15c34"
    sha256 cellar: :any,                 arm64_sonoma:  "4ff5865b001b5bcec4f4aabe9bd1326464a6b5d735dfa678432218b1196d0ef0"
    sha256 cellar: :any,                 sonoma:        "5055ab64b693b48cded0474e35a4d9a0f38a464883efc0b7d021778fa2809e6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a61e3bacb90330ea5e589ba3e2b0fd66d34ae1101426c5044c4869e75f7ce21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8546ccd7ecc87a6f0981c215edc0b269bdb4cb96b2f05615906f4e58d9e51502"
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
