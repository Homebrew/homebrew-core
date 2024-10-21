class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.5.0/shibboleth-sp-3.5.0.tar.bz2"
  sha256 "f301604bd17ee4d94a66e6dd7ad1c3f0917949a4a12176d55614483d78fefe58"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "55bf022aa2b6a6fc966d45553c8ce1288ce76858abf2cabe4761277560076f77"
    sha256 arm64_sonoma:  "df0cd59ffc255be27c05d8fafe3aa245cb572c5aba8e26941f9e7a6d9598efc2"
    sha256 arm64_ventura: "90bbcecdd669cd1e0961c68697c268955b359d4a336408b1cc9d451060612846"
    sha256 sonoma:        "eb9c81c8f10b1890b4d860ef07f709032b033d2b4b8e49def01655528c61dc3a"
    sha256 ventura:       "0e13da6dfef3388f923e184d05ba1dfc9e491f96c8b058e842ee61cb422870c4"
    sha256 x86_64_linux:  "0dd53cb012bdb80804df6c2ae04476966cc9f337b4e5b2df5ee5cdef9017191c"
  end

  depends_on "pkg-config" => :build

  depends_on "apr"
  depends_on "apr-util"
  depends_on "boost"
  depends_on "httpd"
  depends_on "log4shib"
  depends_on "opensaml"
  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  uses_from_macos "krb5"

  def install
    ENV.cxx11

    args = %W[
      --disable-silent-rules
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --with-xmltooling=#{Formula["xml-tooling-c"].opt_prefix}
      --with-saml=#{Formula["opensaml"].opt_prefix}
      --enable-apache-24
      --with-apxs24=#{Formula["httpd"].opt_bin}/apxs
      DYLD_LIBRARY_PATH=#{lib}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  service do
    run [opt_sbin/"shibd", "-F", "-f", "-p", var/"run/shibboleth/shibd.pid"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"shibd", "-t"
  end
end
