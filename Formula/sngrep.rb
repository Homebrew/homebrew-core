class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.6.0.tar.gz"
  sha256 "fd80964d6560f2ff57b4f5bef2353d1a6f7c48d2f1a5f0a167c854bd2e801999"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "791eed53070a6547cb7edae0bfc4d874538812183b9b11759ba050b5ee2eb4e3"
    sha256 cellar: :any,                 arm64_monterey: "090b38f6af7d6768d3b8816186ce8db5f1678f8576513f63bfece2664ed521ea"
    sha256 cellar: :any,                 arm64_big_sur:  "84c553de370ed38fc5775b108fb4aef65da63234c3a2f983bf32f32904926d48"
    sha256                               ventura:        "7b01851336139959d3523cffd9aca8981529fc8cfaa0eff27d9a56264ef8a526"
    sha256                               monterey:       "4d695f06ed5a14c400a0fc2415e84827de36d62f3d4889af7c71447ca7d085b8"
    sha256                               big_sur:        "f8f72fe53910b2ee8557f3e5e954fa759fad39aa3b8ce171b4673e0b6f8eb6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f1379a3381f77310dbdba9239c8e05678b69239dcaf495fb8f96940366fdfc3"
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
