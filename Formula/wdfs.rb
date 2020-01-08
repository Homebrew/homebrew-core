class Wdfs < Formula
  desc "Webdav file system"
  homepage "http://noedler.de/projekte/wdfs/"
  url "http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz"
  sha256 "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5"
  revision 1

  bottle do
    cellar :any
    sha256 "a00329ad59065dc12983272eb1da0e861aa73cbfa8b2edc69393a5a2eba4e49f" => :catalina
    sha256 "edf41371511f947ef47c0ad7575cffb5831687c975f000f51e538133ec42563f" => :mojave
    sha256 "f2f3ad809ea9104bb5fd49b4f903b0465707baf76be3329422ea34aeed8bacb4" => :high_sierra
    sha256 "7aab5f9c3d807f73dfe9df437a15806b74bc5a76cd3cd13e961ea781c7fa32fb" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "neon"
  depends_on :osxfuse

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wdfs", "-v"
  end
end
