class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/2.6.0/shibboleth-sp-2.6.0.tar.gz"
  sha256 "7f23b8a28e66ae1b0fe525ca1f8b84c4566a071367f5d9a1bd71bd6b29e4d985"

  bottle do
    rebuild 1
    sha256 "97a9a2bdc3eae4a3f63169dcdc57e2eabea309f6b79d574fc481700988ad55a1" => :sierra
    sha256 "9e02796184bc54d4d28fefe6919e1fc3cb2f1b986772753442fb507c09e1147c" => :el_capitan
    sha256 "98001f2f772472263a686e38253ed68ad0bad277855c7c9a97943085e7f70f75" => :yosemite
  end

  option "with-apache-22", "Build mod_shib_22.so instead of mod_shib_24.so"

  depends_on :macos => :yosemite
  depends_on "curl" => "with-openssl"
  depends_on "opensaml"
  depends_on "xml-tooling-c"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "log4shib"
  depends_on "boost"
  depends_on "unixodbc"

  depends_on "apr-util" => :build
  depends_on "apr" => :build

  def install
    ENV.O2 # Os breaks the build
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --with-xmltooling=#{Formula["xml-tooling-c"].opt_prefix}
      --with-saml=#{Formula["opensaml"].opt_prefix}
      DYLD_LIBRARY_PATH=#{lib}
    ]
    if build.with? "apache-22"
      args << "--enable-apache-22"
    else
      args << "--enable-apache-24"
    end
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    mod = build.with?("apache-22") ? "mod_shib_22.so" : "mod_shib_24.so"
    <<-EOS.undent
      You must manually edit httpd.conf to include
      LoadModule mod_shib #{lib}/shibboleth/#{mod}
      You must also manually configure
        #{etc}/shibboleth/shibboleth2.xml
      as per your own requirements. For more information please see
        https://wiki.shibboleth.net/confluence/display/EDS10/3.1+Configuring+the+Service+Provider
    EOS
  end

  plist_options :startup => true, :manual => "shibd"

  def plist; <<-EOS.undent
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
        <string>#{prefix}/var/run/shibboleth/shibd.pid</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  test do
    system "#{opt_sbin}/shibd", "-t"
  end
end
