class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.19.tar.xz"
  sha256 "c4b8a2efb85acc600e506605f175298ce3324048e60f4708926d354fe4b5c7a0"

  bottle do
    sha256 "5aca952db2ac97d969bfa8c8f5dd6cbc545f10bff3f7c29180df02be6274a972" => :el_capitan
    sha256 "85856759546617eaca3355dd9386a45b74d492efdfe45a4fc479936695ba51c7" => :yosemite
    sha256 "801fc1c3585f55b1c3e44dac70d88d849023e77a55673e2ad58c931e67f086d2" => :mavericks
  end

  head do
    url "lp:squid", :using => :bzr

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    # https://stackoverflow.com/questions/20910109/building-squid-cache-on-os-x-mavericks
    ENV.append "LDFLAGS", "-lresolv"

    # For --disable-eui, see:
    # http://squid-web-proxy-cache.1019090.n4.nabble.com/ERROR-ARP-MAC-EUI-operations-not-supported-on-this-operating-system-td4659335.html
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

    if build.head?
      system "./bootstrap.sh"
    end
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "squid"

  def plist; <<-EOS.undent
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
    # This test should start squid and then check it runs correctly.
    # However currently dies under the sandbox and "Current Directory"
    # seems to be set hard on HOMEBREW_PREFIX/var/cache/squid.
    # https://github.com/Homebrew/homebrew/pull/44348#issuecomment-143477353
    # If you can fix this, please submit a PR. Thank you!
    assert_match version.to_s, shell_output("#{sbin}/squid -v")
  end
end
