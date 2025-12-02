class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.5.1/shibboleth-sp-3.5.1.tar.bz2"
  sha256 "05da3a09d76c3ba1a5ddd7f919fd942be2d87025f214aba139c2b64b804f9a99"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "033427d4bfe6a3bfc7fa2545f27e956ec4259af610e40777ff7c3bee4bbb6941"
    sha256 arm64_sequoia: "fce3533547b871de8ad8bd019aec8eebbbc4a9a31bf7d35a703af226573a4c3c"
    sha256 arm64_sonoma:  "657db4adad6253944963645bd95bb2af9a823492c840987ed958b38331df2155"
    sha256 sonoma:        "412323e88bd1945e3ed7c968c1bc836afa142d6786cd796ded97812100a6a911"
    sha256 arm64_linux:   "009e69f1c86182e95ef8dbefaf57a79636e48c877fe8f35cc73915020310fda3"
    sha256 x86_64_linux:  "d7a51b5bc378342760b72691ea44b49cd474981fdf1c0909850dbe3fd701da1b"
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
