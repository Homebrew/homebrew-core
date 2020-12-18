class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.2.0/shibboleth-sp-3.2.0.tar.bz2"
  sha256 "639939ee8a7bfc3790e10be92695b35465cd9c89e83a1005c4667ca3d7d66fea"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "13c6f207d88563c9e96514e22a6ec537be5a7ffa020580e4b37fa174f9cd191c" => :big_sur
    sha256 "0e9ce54b4624d94327ad5d0c67ebcb6dc01d4a47f9bef359424c050b332ffe82" => :catalina
    sha256 "d6f41e0976912dd5bf59bada50f91c4254a42eb45b9371a84f9ba8e4177706f3" => :mojave
    sha256 "25841e4f4a66c574dd42f94ad9d2ef18e793b64ff94c7d193740fb5067d8f6bf" => :high_sierra
  end

  depends_on "apr" => :build
  depends_on "apr-util" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "httpd" if MacOS.version >= :high_sierra
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
      DYLD_LIBRARY_PATH=#{lib}
    ]

    args << "--with-apxs24=#{Formula["httpd"].opt_bin}/apxs" if MacOS.version >= :high_sierra

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  plist_options startup: true, manual: "shibd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/shibd</string>
          <string>-F</string>
          <string>-f</string>
          <string>-p</string>
          <string>#{var}/run/shibboleth/shibd.pid</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system sbin/"shibd", "-t"
  end
end
