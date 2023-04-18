class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.4.1/shibboleth-sp-3.4.1.tar.bz2"
  sha256 "bffe3e62e46d86cc75db1093b77fa1456b30da7c930a13708afa0139c8a8acc1"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "39bc3e88f3ebf7701f1a730807d1983751a48d173d1cba54040748b787afa6a0"
    sha256 arm64_monterey: "97816635f3d80e3acde5d5e5928704bcc3e8534cbb11981be5daecd7f65b7a8d"
    sha256 arm64_big_sur:  "edb8297894370d0bdf696fa8de765b4030f157871754c709ce07e78aed4b3110"
    sha256 ventura:        "7b2a0d9ca98f69e14a82030c6a81fcc842f35ec010b4427cf4628018ee169f2a"
    sha256 monterey:       "bc2d86fd34a55a12a8d542ebf7eefdd5d4cf4697f20cc6d9bdf8c4de0b3d005e"
    sha256 big_sur:        "b1f897b4d6f5d637e3da43b008a3915e73291313c307c2c820a7a5ccec1e15f2"
    sha256 x86_64_linux:   "4602cec97ab32f4862f5778aa7fe56924d3184acc197bbe8e1c616c265010d79"
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

  service do
    run [opt_sbin/"shibd", "-F", "-f", "-p", var/"run/shibboleth/shibd.pid"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"shibd", "-t"
  end
end
