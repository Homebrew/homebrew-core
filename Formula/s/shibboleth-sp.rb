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
    sha256 arm64_sequoia: "a9586efb0a7b274074ed45bd22b33737a881571e95d3324bf64ed8d17cca7072"
    sha256 arm64_sonoma:  "36723380e18cab9652db4801a9dabb60fa26c5092e2aabd0b35853e70b99fb9b"
    sha256 arm64_ventura: "e8544b105025133d3c6e9d9ea2119ed0d41fd8caf79eb97771cf0de80c341623"
    sha256 sonoma:        "1618cd8310354dde562fea2d079d96eb8ab2b1309588ac365435df416f37f4b7"
    sha256 ventura:       "86bf86c47d12d6db98fe3d8925f6a2eaf7d6cd417b1aa052d781e6cf0d6fee8f"
    sha256 x86_64_linux:  "75409a8d3ecf93e527e7243f9c1b3e523e9e1d7246835c2806bb77afce5b46e9"
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
