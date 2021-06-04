class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v4/squid-4.15.tar.xz"
  sha256 "b693a4e5ab2811a8a854f60de0a62afbbf3a952bb1d047952c9ae01321f84a25"
  license "GPL-2.0"

  livecheck do
    url "http://www.squid-cache.org/Versions/v4/"
    regex(/href=.*?squid[._-]v?(\d+(?:\.\d+)+)-RELEASENOTES\.html/i)
  end

  bottle do
    sha256 arm64_big_sur: "87d1e9c13ebf59f67218b7385eecb7690eac4dacf2c4d30a536001bfdc846812"
    sha256 big_sur:       "9ea3f1e311ff4be0efdafbeb3dd87a4592e66af17b6a5fb01a6f58f7bce72075"
    sha256 catalina:      "731cd0467205f2ad7aef705f2a39d4309870259b46ffab1248826cb00eea5011"
    sha256 mojave:        "ce9248b843b329305536ec35a7592dc931d403e2ddeb3d3d023f885a508945d6"
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
