class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.0.2/shibboleth-sp-3.0.2.tar.bz2"
  sha256 "7aab399aeaf39145c60e1713dbc29a65f618e9eca84505f5ed03cee63e3f31a3"
  revision 3

  bottle do
    sha256 "b1d3c2cb3c8a6c3677c535bc823681fe71395ac30e7de205051745a12a01330b" => :mojave
    sha256 "8968449274a5e3f545d69bb3c4cfabbc78b98046d6ad73fbd2749c52f6b372eb" => :high_sierra
    sha256 "40c50c27cdf4b5fb23d9dda3a01eed70abd6a4b1fc7536a5e88589cec1d3706c" => :sierra
  end

  depends_on "apr" => :build
  depends_on "apr-util" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "httpd" if MacOS.version >= :high_sierra
  depends_on "log4shib"
  depends_on :macos => :yosemite
  depends_on "opensaml"
  depends_on "openssl"
  depends_on "unixodbc"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

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
