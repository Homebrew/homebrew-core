class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.5.0/shibboleth-sp-3.5.0.tar.bz2"
  sha256 "f301604bd17ee4d94a66e6dd7ad1c3f0917949a4a12176d55614483d78fefe58"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "105caae3db423a4ae2ef4d3deb4f25557e39a2b7469094129222bf6e26025cc1"
    sha256 arm64_sequoia: "7be03c283bd03ff2963f41bb949c9a2434b56fab73ef26864e5ed54169b6a833"
    sha256 arm64_sonoma:  "e37293eaab76478845e28a24c16e77ae9e4eb218c7e2d0aeeff93038a87182f1"
    sha256 sonoma:        "2ccea3f29a012722cef174cbadda353cbea92967145d05a2b79e0c8ae90036c9"
    sha256 arm64_linux:   "50f2e227a17c72075fbde051cc9c493d2de9761afdbe701cfaf59e1aed393648"
    sha256 x86_64_linux:  "0a312b12f0b6a2dcc7955f7778f8afcab6ceef8fdaf14bb1f904fb2066e56dbc"
  end

  depends_on "pkgconf" => :build

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

    (var/"run/shibboleth").mkpath
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
