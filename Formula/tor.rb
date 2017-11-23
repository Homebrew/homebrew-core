class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://tor.eff.org/dist/tor-0.3.1.8.tar.gz"
  mirror "https://www.torproject.org/dist/tor-0.3.1.8.tar.gz"
  sha256 "7df6298860a59f410ff8829cf7905a50c8b3a9094d51a8553603b401e4b5b1a1"

  bottle do
    sha256 "0f5c458a2ae21a325d04ac74505301fcd3179fe44d593ba56a7d49f899d7521a" => :high_sierra
    sha256 "65de0810f6725a84d46a891710076d24e1cea3e3c411b81405e7957cfdce9bf7" => :sierra
    sha256 "f6827d77160c2e3f6794eea3a6dfb35ba342b0f6e62cd695d4b4a212ec81a265" => :el_capitan
  end

  devel do
    url "https://tor.eff.org/dist/tor-0.3.2.5-alpha.tar.gz"
    mirror "https://www.torproject.org/dist/tor-0.3.2.5-alpha.tar.gz"
    sha256 "1b61d280310e2f5e1472e567cdae965392902b89babd33e211356a02c28c5c15"
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
