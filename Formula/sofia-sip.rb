class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sofia-sip/sofia-sip/1.12.11/sofia-sip-1.12.11.tar.gz"
  sha256 "2b01bc2e1826e00d1f7f57d29a2854b15fd5fe24695e47a14a735d195dd37c81"
  revision 3

  bottle do
    cellar :any
    sha256 "4f34083bac516844beb3118472e6ec88fc553eb498352ee2a558e932fea2dafe" => :mojave
    sha256 "a56150da69be88c575c73abfbb1b9999c2ab11ff9d2a9ec6f8df380d1409416c" => :high_sierra
    sha256 "3e2170375189539c79f9af70119956ebadf3703b8ee72db8c4fbcc2f17b5ac45" => :sierra
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
