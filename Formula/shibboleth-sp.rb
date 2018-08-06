class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.0.2/shibboleth-sp-3.0.2.tar.bz2"
  sha256 "7aab399aeaf39145c60e1713dbc29a65f618e9eca84505f5ed03cee63e3f31a3"

  bottle do
    sha256 "ea68592d27b642e356112d9f41ed43a449e8c206628ccdffffdead4742ac30bd" => :high_sierra
    sha256 "95f5e6ea5ad8195d0013f419280c262cc9a8d10b5470962347dc6e62c0d2dd30" => :sierra
    sha256 "ac57fa26bc3e53d7fa7640b3ed437148a6fb47648afdc7fb402e43de1d4fd7c2" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :macos => :yosemite
  depends_on "curl" => "with-openssl"
  depends_on "httpd" if MacOS.version >= :high_sierra
  depends_on "opensaml"
  depends_on "xml-tooling-c"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "log4shib"
  depends_on "boost"
  depends_on "unixodbc"

  depends_on "apr-util" => :build
  depends_on "apr" => :build

  needs :cxx11

  def install
    ENV.O2 # Os breaks the build
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

    if MacOS.version >= :high_sierra
      args << "--with-apxs24=#{Formula["httpd"].opt_bin}/apxs"
    end

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  def caveats
    mod = build.with?("apache-22") ? "mod_shib_22.so" : "mod_shib_24.so"
    <<~EOS
      You must manually edit httpd.conf to include
      LoadModule mod_shib #{opt_lib}/shibboleth/#{mod}
      You must also manually configure
        #{etc}/shibboleth/shibboleth2.xml
      as per your own requirements. For more information please see
        https://wiki.shibboleth.net/confluence/display/EDS10/3.1+Configuring+the+Service+Provider
    EOS
  end

  plist_options :startup => true, :manual => "shibd"

  def plist; <<~EOS
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
