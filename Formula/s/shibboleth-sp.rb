class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.5.2/shibboleth-sp-3.5.2.tar.bz2"
  sha256 "c4e92c11e56adaa5ea480aba1d78c5f30fbd5d1badb4a13bdd85684bd801298a"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "339c9579747a7ea9f59bcf07d27e54060929ab44549922d266e4e39f1a015f51"
    sha256 arm64_sequoia: "27e58347d47a561d0a05981c4c718340656ea783813436fc6fd99d5a421a03e9"
    sha256 arm64_sonoma:  "6a0f175f759d499075c499c22879f98495e2fcc5d65c7a7bc341be2924505a3c"
    sha256 sonoma:        "2f8d41cf20b047da3c6a5bc7c0cdf50eebc400d57781a4fb91b9bf2470df0c87"
    sha256 arm64_linux:   "b7f78e39e8dfb3f8b065dfba2012cc49d103fe314fdd1d987bb891363a19eb8f"
    sha256 x86_64_linux:  "b1ef8dbde97fc0158660d63a17852d64b24ff246bf4fb59bb880e6a4d35e1837"
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
