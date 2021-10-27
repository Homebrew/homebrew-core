class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v4/squid-4.17.tar.xz"
  sha256 "cb928ac08c7c86b151b1c8f827abe1a84d83181a2a86e0d512286163e1e31418"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.squid-cache.org/Versions/v4/"
    regex(/href=.*?squid[._-]v?(\d+(?:\.\d+)+)-RELEASENOTES\.html/i)
  end

  bottle do
    sha256 arm64_monterey: "4c922c513876e0eac5e5eea248e75f5d7b15ac934defbb29531b547211ca2ed5"
    sha256 arm64_big_sur:  "ab7f9bcb273ce10621b219b3fa36306039a025d0a61745e061ff7135c2c5ce02"
    sha256 monterey:       "6c60aef5ac07e2350e67ed8c190bb023152e3fab0ab676b95e77cb3b626f0c24"
    sha256 big_sur:        "cd2c5c2dc8843d49adf1cf7b7c0b51567a0ad6d8293d3779006906695348e4ec"
    sha256 catalina:       "4e4cb257f1a82777ba111d1c4a80de8398b7fa9e330cd2506f698e85a6057be9"
    sha256 mojave:         "14b611332f6cb8001e15e875f02192b9ce2ca600a2a19f125cd51402032d102e"
    sha256 x86_64_linux:   "ff99b1569d2fc90eea26ff2aadff55670eeacf2469fca3e713fb00ee6e77d10b"
  end

  head do
    url "lp:squid", using: :bzr

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  def install
    # https://stackoverflow.com/questions/20910109/building-squid-cache-on-os-x-mavericks
    ENV.append "LDFLAGS", "-lresolv"

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

  plist_options manual: "squid"

  def plist
    <<~EOS
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
