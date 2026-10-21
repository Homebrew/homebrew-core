class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.6.0/shibboleth-sp-3.6.0.tar.bz2"
  sha256 "17e071191db795b21e89d7793fd4603e2d1375d7ee8ff002a54c5d2c8ce77a2f"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "32b6a15b4b194bbeee48e7f97d167954cdc9bc80e7ad231d6d85c646e0714650"
    sha256 arm64_tahoe:       "310022c7d540e88197aa85fd0e438d5bb178fd07209209a790f530e81f8e4e12"
    sha256 arm64_sequoia:     "4e5c506fafc3b73752e30309a6accd074762d83488bcb10c0f99839853a0a99e"
    sha256 arm64_linux:       "35729d64ab8cb59f36c464a6998ab31c67d17b7c098f16621f2d8f307be1790e"
    sha256 x86_64_linux:      "a064975d662b3b11d94a0e1572c68eefd9ad810c685d6eec4b23ef95325a53ab"
  end

  depends_on "pkgconf" => :build

  depends_on "apr"
  depends_on "apr-util"
  depends_on "boost"
  depends_on "httpd"
  depends_on "log4shib"
  depends_on "opensaml"
  depends_on "unixodbc"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  uses_from_macos "krb5"

  # Apply FreeBSD patch to fix build with Clang 19
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/319b9c0cd3556550f107a1b4d8f083b0eba665b9/security/shibboleth-sp/files/patch-shibsp_util_IPRange.cpp"
    sha256 "fb1585b6e2e2ff44bf4460dcf6388d9657804f3938c1ead728864482d7537f06"
    type :unofficial
  end

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
