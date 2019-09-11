class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sofia-sip/sofia-sip/1.12.11/sofia-sip-1.12.11.tar.gz"
  sha256 "2b01bc2e1826e00d1f7f57d29a2854b15fd5fe24695e47a14a735d195dd37c81"
  revision 3

  bottle do
    cellar :any
    sha256 "a92c49f6a27cf0fa4912d7e9a77c61b6e93d78686a758e8cd599f93b93e574cf" => :mojave
    sha256 "dcb694f4f51bfbf58a23e39a97b75ac03eb140d3d25cfb735d9c97a38d25f203" => :high_sierra
    sha256 "eba667bc978220cf4bdf3497d37127dc3b8da9257d0eed8dfb36fa7e739dc7da" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
