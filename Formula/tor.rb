class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://tor.eff.org/dist/tor-0.3.1.9.tar.gz"
  mirror "https://www.torproject.org/dist/tor-0.3.1.9.tar.gz"
  sha256 "6e1b04f7890e782fd56014a0de5075e4ab29b52a35d8bca1f6b80c93f58f3d26"

  bottle do
    sha256 "cb3c7bf2ce43c1f2a075e2f75160e0f52d26c2b7faa6630a34fbf80c48c7bea3" => :high_sierra
    sha256 "b58f4bba55cfc441e411907963ce07d62dc295789274a84e0308f9c3879465c0" => :sierra
    sha256 "7368d59d939de0f3783be8ea568086fe4dfd9cdd423daf4bbb9c29e977f9cbc4" => :el_capitan
  end

  devel do
    url "https://tor.eff.org/dist/tor-0.3.2.6-alpha.tar.gz"
    mirror "https://www.torproject.org/dist/tor-0.3.2.6-alpha.tar.gz"
    sha256 "6770cf76973dcfc126ce98a7b1bf55cd0dffdacaf77f7389a08218559e9b2280"
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
