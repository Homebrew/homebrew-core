class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.3.0/shibboleth-sp-3.3.0.tar.bz2"
  sha256 "f175bd0dc695a8b7cbe78f6156b14f7f407e1742d045d9a8e3f2cf1078c04704"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "738bd343b9f76ecd309ab8ae3376984c01b3a5a8300d4bd91815a4035ac94b97"
    sha256 arm64_big_sur:  "c809a0f2ce20af11fc0b15fd87146ac1606064c7a6b713b43b6d96723e3dad2b"
    sha256 monterey:       "d5edc5708519b4dbe5e23f465c19909e9760e9d91970995dc1ecb31c668b438c"
    sha256 big_sur:        "5d0b4c8fa81c68acba6283b76721979e985730fd8425c12c73b9c66740d7d70d"
    sha256 catalina:       "2c64a07ede27423b2f21a93a7028c0071a60723280c0da53a1173be2a09268b4"
  end

  depends_on "apr" => :build
  depends_on "apr-util" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "httpd" if MacOS.version >= :high_sierra
  depends_on "log4shib"
  depends_on "opensaml"
  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    ENV.cxx11
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --with-xmltooling=#{Formula["xml-tooling-c"].opt_prefix}
      --with-saml=#{Formula["opensaml"].opt_prefix}
      --enable-apache-24
      DYLD_LIBRARY_PATH=#{lib}
    ]

    args << "--with-apxs24=#{Formula["httpd"].opt_bin}/apxs" if MacOS.version >= :high_sierra

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  plist_options startup: true
  service do
    run [opt_sbin/"shibd", "-F", "-f", "-p", var/"run/shibboleth/shibd.pid"]
    keep_alive true
  end

  test do
    system sbin/"shibd", "-t"
  end
end
