class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sofia-sip/sofia-sip/1.12.11/sofia-sip-1.12.11.tar.gz"
  sha256 "2b01bc2e1826e00d1f7f57d29a2854b15fd5fe24695e47a14a735d195dd37c81"
  revision 4

  bottle do
    cellar :any
    sha256 "2f00e1e117d44b4cea76f7d6434e80e77884b3cee8f31f1fd3e8c203911d1497" => :catalina
    sha256 "a7d98db04406b64b6c84fbee215cccb8f44b3342318d22c8adef65865096df22" => :mojave
    sha256 "52d32ecd60bcc55d2e4569be650e9b11fd1c75e1b14d44145773717bb6693a6c" => :high_sierra
    sha256 "95a892ab2ae71eb09d5aa22c6e30a2336376d34321c54032b6d03106a96dc631" => :sierra
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
