class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v4/squid-4.8.tar.xz"
  sha256 "78cdb324d93341d36d09d5f791060f6e8aaa5ff3179f7c949cd910d023a86210"
  revision 1

  bottle do
    sha256 "429050d3989194432d4f71436dce1d5b71bca1e2bbb6e9acf414f43a35e53bd0" => :catalina
    sha256 "9a270ba2224d4a6a1980aadac4c9c8dee77a7bf228d08e5795d659e2fc7635d5" => :mojave
    sha256 "8de312f6d60ae2afefe1e16c3b90add226b66cf73ff32fed9960285daf5a834b" => :high_sierra
    sha256 "47a380fbb860aedd22f08ed93af9caeb0b8cd9e1fc3efa68e0e7a49b7c79478e" => :sierra
  end

  head do
    url "lp:squid", :using => :bzr

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  def install
    # https://stackoverflow.com/questions/20910109/building-squid-cache-on-os-x-mavericks
    ENV.append "LDFLAGS", "-lresolv"

    # Patch for detection of OpenSSL 1.1, submitted upstream
    # https://github.com/squid-cache/squid/pull/470
    inreplace "configure", "SSL_library_init", "SSL_CTX_new"

    # For --disable-eui, see:
    # http://www.squid-cache.org/mail-archive/squid-users/201304/0040.html
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --enable-ssl
      --enable-ssl-crtd
      --disable-eui
      --enable-pf-transparent
      --with-included-ltdl
      --with-openssl
      --enable-delay-pools
      --enable-disk-io=yes
      --enable-removal-policies=yes
      --enable-storeio=yes
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "squid"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/squid</string>
        <string>-N</string>
        <string>-d 1</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/squid -v")

    pid = fork do
      exec "#{sbin}/squid"
    end
    sleep 2

    begin
      system "#{sbin}/squid", "-k", "check"
    ensure
      exec "#{sbin}/squid -k interrupt"
      Process.wait(pid)
    end
  end
end
