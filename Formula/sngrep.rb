class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.5.0.tar.gz"
  sha256 "c41620c02982fe87a443ccc795cc8c7fe7cf3d55338b8723f345b685bc153f4e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d150b4b24b10111f47c0e7ba540dda9790b2a6a3c8c8db0d479323ab4517561e"
    sha256 cellar: :any,                 arm64_big_sur:  "08602359207454d252548a9218ca1b953fa5486eb53ef7c2a5746e6f2b8e11a3"
    sha256                               monterey:       "c8673a577a984a7fd873e4872551a7de85b9c0a91a764526d6c4e32026126c25"
    sha256                               big_sur:        "33d2f47c4476b0d087987843f546c73ee542d09b223c28ebea4f8624fe6306b8"
    sha256                               catalina:       "b3b23a3c3344dafcff7f5d954a99eac69fffeb77ff5ca60624c2c8f990abef18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b796a3f8b22997bdb44f1f01ab9ddfc67135e84dc365ce6902a1f5edfd7b5d0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw" if OS.linux?

    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
