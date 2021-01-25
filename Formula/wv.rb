class Wv < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.io/"
  url "https://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha256 "4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d"
  revision 1

  bottle do
    sha256 "6e6499eca2f6ab68a58a4a0548ac4954eec052d20558dc1bd834cc4bb030e0cc" => :big_sur
    sha256 "36bac1865cab3a50dafdf0477bb914d6c9df08c386b5586951f6681e5d5f73ad" => :arm64_big_sur
    sha256 "c617efb5a72bf2dbca4a3c85fdb59460ce6aaaf21b1f1db1e89f53ac3fc07224" => :catalina
    sha256 "e3b62df7fad6fefbd233abc45ede4f9705b447df51433e0129a82d98dc321811" => :mojave
    sha256 "470ecfe6b84e931d4c4363b8274a04d42b2e2c3b6c5f50bc12b55a7fda6f5acb" => :high_sierra
    sha256 "7df867080d9b2edb57780c5f971a4a22d01c301aff70c1af7a6ce13385828908" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "libwmf"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
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
end
