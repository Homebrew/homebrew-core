class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.8.tar.gz"
  sha256 "f39fded8dc9ef0b7a41319f223dd4afa348bb2418bea578ed281557726829728"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "9f4802e1906e6177e83aff155174187fafdac32401d38c22af472035801c01c2" => :big_sur
    sha256 "18b64ed24e66e3030fd8cf53ac64293d657093bfede0ccb7929621efe5edd146" => :arm64_big_sur
    sha256 "489e6591c8008cbec241633ef0697c609aef20b02b9d97e7249c35d88af15d70" => :catalina
    sha256 "d645f96ed390b34ce5e4fe9b01a687722b4046db196c0933546a7bb7a964d55a" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"

  def install
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
