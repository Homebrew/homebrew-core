class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.4.1/shibboleth-sp-3.4.1.tar.bz2"
  sha256 "bffe3e62e46d86cc75db1093b77fa1456b30da7c930a13708afa0139c8a8acc1"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "5f9d2ea91d30aea4c625a41b46d92d6c8f2046efc425aa7d420e76f50185f3d2"
    sha256 arm64_sonoma:   "dd40b2194765feea63309c8b7c23abdab493d83bd9c3a430c780dfe8b2b17db4"
    sha256 arm64_ventura:  "c99c11c8ebc76a48690cfe691b9ceb24839f2c720a28e147acbf49107222e730"
    sha256 arm64_monterey: "dd191ccaf4626eccceea95ba9a5df763d9504c2e2b6acb45351376ab4c35308d"
    sha256 arm64_big_sur:  "2deccabb99d0c1687834eaad2700ab6e9a175352c589842b8c14ef305461bf83"
    sha256 sonoma:         "bc88e9e428f073a1466a892029d4ce76ae95d15ce260a4e448974a5255b4628b"
    sha256 ventura:        "6aac334d8fce2141b7468ccc14afbbd89ab01a6ea5af50b115ec1f7c3bcb078c"
    sha256 monterey:       "81b3cc3e0f6a464de58f59bbf7a7b972a464ed9e2d43f4c9a803139aa3a1d119"
    sha256 big_sur:        "ccf778c36c9beea10ccb74d9a46c062af6509be8b7068cbfc4c9b922fc0b6d83"
    sha256 x86_64_linux:   "ec22788a7519d49dfbf12c13f652f8c80fc8adc32a9363e40a30c31568f9483f"
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
