class Wv < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.net/"
  url "https://deb.debian.org/debian/pool/main/w/wv/wv_1.2.9.orig.tar.gz"
  mirror "https://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha256 "4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    skip "Not actively developed or maintained"
  end

  bottle do
    sha256 arm64_sonoma:   "282ed73a67d00953c4fbd390a82f3d1148822dbe103beaa7f81cfdc92ca8194a"
    sha256 arm64_ventura:  "af7ed2ef919eb856fd37e52bce5d7d5ff8ed39785969aeb565b07c62160807c9"
    sha256 arm64_monterey: "a96f5e5c182887f42939ab725f79d4a9f31801d3f92a19da1e08da6477edcfe7"
    sha256 arm64_big_sur:  "36bac1865cab3a50dafdf0477bb914d6c9df08c386b5586951f6681e5d5f73ad"
    sha256 sonoma:         "fb64e12f1f800257a79b538a3651a0abcc6bea703e91843f1ab84128470ae988"
    sha256 ventura:        "96dd06b5837281f09cbb87bc62ba805285c1ca2c960420f6903962618755d92e"
    sha256 monterey:       "376a60947357ebe4662e6f197745da5c76e75c0a5559456711f95b138519eba6"
    sha256 big_sur:        "6e6499eca2f6ab68a58a4a0548ac4954eec052d20558dc1bd834cc4bb030e0cc"
    sha256 catalina:       "c617efb5a72bf2dbca4a3c85fdb59460ce6aaaf21b1f1db1e89f53ac3fc07224"
    sha256 mojave:         "e3b62df7fad6fefbd233abc45ede4f9705b447df51433e0129a82d98dc321811"
    sha256 high_sierra:    "470ecfe6b84e931d4c4363b8274a04d42b2e2c3b6c5f50bc12b55a7fda6f5acb"
    sha256 sierra:         "7df867080d9b2edb57780c5f971a4a22d01c301aff70c1af7a6ce13385828908"
    sha256 x86_64_linux:   "af62ebf3c81d88115b669a44a957c3f0128702364387aea07fdc1812e7895bad"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "libwmf"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work around build errors with newer Clang
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types -Wno-int-conversion"
    end

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make"
    ENV.deparallelize
    # the makefile generated does not create the file structure when installing
    # till it is fixed upstream, create the target directories here.
    # https://www.abisource.com/mailinglists/abiword-dev/2011/Jun/0108.html

    bin.mkpath
    (lib/"pkgconfig").mkpath
    (include/"wv").mkpath
    man1.mkpath
    (pkgshare/"wingdingfont").mkpath
    (pkgshare/"patterns").mkpath

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/wvSummary #{test_fixtures("test.pdf")} 2>&1")
    assert_match "No OLE2 signature", output

    assert_match version.to_s, shell_output("#{bin}/wvHtml --version")
  end
end
