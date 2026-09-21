class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.6.0/shibboleth-sp-3.6.0.tar.bz2"
  sha256 "17e071191db795b21e89d7793fd4603e2d1375d7ee8ff002a54c5d2c8ce77a2f"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "99f26005e70c6e13a002cdd7f3f01631ba648b2203568899bd720a759b2ccd1a"
    sha256 arm64_tahoe:       "dfb3d1935dd2197b2bb2ef630c91c989fcee45fd625e93363ea3de0d79432ff8"
    sha256 arm64_sequoia:     "301f8e1fada41eba38dc88504ac602f5f95fe2d1c99f30f629be136baf12d463"
    sha256 arm64_linux:       "db162748b883eda3d59c56fe647db3bf12ceb410949f1fdf5d3c56b71d6056f9"
    sha256 x86_64_linux:      "fb6b6a2aefd86a36d6402a452f2652f36afc7413f5b50ae6cd8f82cc4bd48176"
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
      --with-xmltooling=#{formula_opt_prefix("xml-tooling-c")}
      --with-saml=#{formula_opt_prefix("opensaml")}
      --enable-apache-24
      --with-apxs24=#{formula_opt_bin("httpd")}/apxs
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
