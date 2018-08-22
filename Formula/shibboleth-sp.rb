class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.0.2/shibboleth-sp-3.0.2.tar.bz2"
  sha256 "7aab399aeaf39145c60e1713dbc29a65f618e9eca84505f5ed03cee63e3f31a3"
  revision 1

  bottle do
    sha256 "12dd8db6bf6142c6fb2be24c5513e9b27cae0830b234f52a40cd92c3a39129a9" => :mojave
    sha256 "c135bc6082bdfcf28d4db188a0263d08e84fb11bb79a79d785aca8f16da7ef05" => :high_sierra
    sha256 "2d2dcdeeaf7b23fa5fb09633dc73804bd0b917dfa6bf143fae096fcb3a39ef74" => :sierra
    sha256 "ce407e628b733ce46224e30cd82cb33e850a727df71b1901ec981f651b274e08" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :macos => :yosemite
  depends_on "openssl"
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
