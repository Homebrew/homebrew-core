class Wv < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.io/"
  url "https://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha256 "4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d"
  revision 1

  bottle do
    sha256 arm64_monterey: "a96f5e5c182887f42939ab725f79d4a9f31801d3f92a19da1e08da6477edcfe7"
    sha256 arm64_big_sur:  "36bac1865cab3a50dafdf0477bb914d6c9df08c386b5586951f6681e5d5f73ad"
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
