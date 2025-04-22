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

  bottle do
    sha256 arm64_sequoia: "0569ff4651fd7d6700c65c25790574f19066174c768959ae2064aea20ad5a99b"
    sha256 arm64_sonoma:  "0a46e994d409ba22543dc7bc7736238bcce908efc32d987ce0c043ceced97a70"
    sha256 arm64_ventura: "e5d6b7a4b089ab17ec32cd0808c1d5f0c7de2190df46a0a02bb00c1561d1cfca"
    sha256 sonoma:        "3266a747920724d2be0e306610ebfc6348cab7d02331702d398dc6fa671c7dfc"
    sha256 ventura:       "05d2cc8a93f269863e7dee8ce5806dd840b8d8ba6bf0619cb425b8635a1a6dc3"
    sha256 arm64_linux:   "8543a12970a4d9909660f736f4a4a4fe10b0b26ead2c011d32aa39614fa068d2"
    sha256 x86_64_linux:  "5d6bdcc1ac27a3cadcc7e5b0d38d8718ec1e20ee599f2eb2c373af7d24b34d7e"
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
