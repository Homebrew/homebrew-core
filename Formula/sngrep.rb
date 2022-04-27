class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.5.0.tar.gz"
  sha256 "c41620c02982fe87a443ccc795cc8c7fe7cf3d55338b8723f345b685bc153f4e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c2b0c9b6b923a64a519778ed92fd05ae24d0dc4dafbd86cc60e6019bd5b10051"
    sha256 cellar: :any,                 arm64_big_sur:  "af50e434f053ec58cb0e87623e325bb19368877c3f19721bcd3e575a9820cb1a"
    sha256                               monterey:       "b7014b432aa4bb37eb1f3a8cf73893c8870d328ba469705197591c0708fec414"
    sha256                               big_sur:        "f187a94e3f322d2d997e9627d286e6b24ccfb8f63ba35ab31d2cb4d6d6b2a154"
    sha256                               catalina:       "78fd04e13e65e6ef0331786f5b68d1e8c99ae65c24d028f99ea887395c391515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc3738ac2c7b0b377f1ba3cf481fcec78080a3871c4faafe94d830f9dd5aead1"
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
