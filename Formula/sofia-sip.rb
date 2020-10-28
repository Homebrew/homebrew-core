class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.2.tar.gz"
  sha256 "b9eca9688ce4b28e062daf0933c3bf661fb607e7afafa71bda3e8f07eb88df44"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "2f00e1e117d44b4cea76f7d6434e80e77884b3cee8f31f1fd3e8c203911d1497" => :catalina
    sha256 "a7d98db04406b64b6c84fbee215cccb8f44b3342318d22c8adef65865096df22" => :mojave
    sha256 "52d32ecd60bcc55d2e4569be650e9b11fd1c75e1b14d44145773717bb6693a6c" => :high_sierra
    sha256 "95a892ab2ae71eb09d5aa22c6e30a2336376d34321c54032b6d03106a96dc631" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
