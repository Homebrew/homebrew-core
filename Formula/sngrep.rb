class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.7.0.tar.gz"
  sha256 "2e5ba3a4d6486ea00bd73d2cceff383ba162dcd6d0170ae74cfa3b1c206e2cb1"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e8f6d7da1a5362d2056f0e49430026ad83098ce813331c3c32caa7c495b3da64"
    sha256 cellar: :any,                 arm64_monterey: "d9835ceb28b18b5e8f4141423b1dd4de5c436cceedaa85ee1490497863667c70"
    sha256 cellar: :any,                 arm64_big_sur:  "c2455f214c1d24c99643320842f12ea63d79f59631ca334ff2d341e2e8fbddc8"
    sha256                               ventura:        "aa7dfb7bd3a5eb2e9882475f6fbc7b77a08d25d67c988c6c405911ea727ad3ab"
    sha256                               monterey:       "308a7206a0c6fccb75965cabc4051183b7b849c06771640742e5ca2c24bbbcab"
    sha256                               big_sur:        "771bc6dd65f0594fcf163c0409365bf216eabe0d4d33e4e675645b3fc34ce350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f37d6459d16e6d983ff4e52af07d38b354b4fa0d5855ed0a34bf3968e3f1a39"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw" if OS.linux?

    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
