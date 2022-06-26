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
    sha256 arm64_monterey: "e90f7108926a0492b61d482442ca3363e01fe4ee0a5030d3d5128ee7bce62c04"
    sha256 arm64_big_sur:  "3627b9b94793331278c868f3f50c0feb832db68545ee689445efcb17e56abd99"
    sha256 monterey:       "3c5fddd0234a1d201aebf7cda85223212e0e3ccbded613e3258cc014d2811c0d"
    sha256 big_sur:        "6adfa5b54297937bf4bc1a5abba4f57dd5bca91647c3b9cac9a0b7a86c8ca444"
    sha256 catalina:       "82e21f772932a9edbbefc1288e26e6537b23cbb74dc7eb6d8c814486157789c9"
    sha256 x86_64_linux:   "53dbce9a0a34d7a61083ba1130c3699d0c0657a6552c16df84b4c07b25a35ce8"
  end

  depends_on "apr" => :build
  depends_on "apr-util" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "httpd"
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
      --with-apxs24=#{Formula["httpd"].opt_bin}/apxs
      DYLD_LIBRARY_PATH=#{lib}
    ]

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
