class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.3.5.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.3.5.tar.gz"
  sha256 "616a0e4ae688d0e151d46e3e4258565da4d443d1ddbd316db0b90910e2d5d868"

  bottle do
    sha256 "1a358ca1ea1c73cbc52b0a011314954da92fed0fa8e5bffd01b3ed1f97a6fc62" => :catalina
    sha256 "0f21e143f0d968ab33014e2c5ac101addb3de0cb4299722e0674eb4d29972064" => :mojave
    sha256 "96465afffe32f2dbb9284406e145297f583cb8c5fdfceec3c133371975f824b0" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "tor"

  def plist
    <<~EOS
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
