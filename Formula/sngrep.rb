class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.6.0.tar.gz"
  sha256 "fd80964d6560f2ff57b4f5bef2353d1a6f7c48d2f1a5f0a167c854bd2e801999"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2bbb0e2441c8192002e427ba0b5a3e8673cee8689fd5befebd0f3ba0532e3cb2"
    sha256 cellar: :any,                 arm64_big_sur:  "69a7368edfbff2b60ed13cf1dbd9891ca8346bc4764108441c48e28a27ff08cc"
    sha256                               monterey:       "c0d3b02aa03ce6c44e7d0a14e06d34bea256934504fce358c0ad94308b4e410f"
    sha256                               big_sur:        "d02e2bb89ebe085ba45d1bf9ccd3da89b4bb2b79dd69942bf56a1b3e70acfad4"
    sha256                               catalina:       "f66d29b77e3a75b7824eccba63ee8e7c4d97e684afbb7cb1dccf79ce5ca8a273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f787893debb7a1c5e9bfc7dd4d951f7806cfd6d0c9a04f53579f421c5f5bebc5"
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
