class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.3.8.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.3.3.8.tar.gz"
  sha256 "3cf5b4fea2491cbfefa1077bf1b2855e169052d381bd920cd57aa9bfaff6b3a5"

  bottle do
    sha256 "d54c7d7fe7d7beb05f3ab03547567766abf12cfb3ff628ec58210e62b65a61d4" => :high_sierra
    sha256 "4761338cb4efe9c5b9f2626900fb77e70e228fdc1c2985a7ac091651b9dd6067" => :sierra
    sha256 "d78e9e766a25c543200297f079d0656d25187b692dd99f76f27d5b82cb4ea92a" => :el_capitan
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.4.4-rc.tar.gz"
    sha256 "d9f556e3213e12bd989666da778c043d4c78b448290fcccee0f7590c08b9505f"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl"
  depends_on "libscrypt" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-libscrypt" if build.without? "libscrypt"

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "tor"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/tor</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/tor.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/tor.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
  end
end
