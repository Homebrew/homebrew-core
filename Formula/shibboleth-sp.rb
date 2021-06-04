class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.2.2/shibboleth-sp-3.2.2.tar.bz2"
  sha256 "e5db65b39cd3f078ff683c792558aa549d46ffc627a70faf3ef4637b2892e767"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d5513a1d8323699dd8550e7a182f4b92807497f04ab437e8efda22eb9751f654"
    sha256 big_sur:       "7b89a1e5933cc0682b3e893741eef2300421d1bed3352d4c7a5ca5de17ba4765"
    sha256 catalina:      "b16c98790433ca78ef9f6bc8a14a70d4f601b8b8079298c4252ed9c5ad0eba6e"
    sha256 mojave:        "790a6bfb5d5961170a380847a8b808283842bb9357d6b12505fe6123b99a6d1e"
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
