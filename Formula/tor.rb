class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://tor.eff.org/dist/tor-0.3.1.7.tar.gz"
  mirror "https://www.torproject.org/dist/tor-0.3.1.7.tar.gz"
  sha256 "1df5dd4894bb2f5e0dc96c466955146353cf33ac50cd997cfc1b28ea3ed9c08f"

  bottle do
    sha256 "fd269435de52eee46657a6e03375dfd68ad532d003c34debe4b4a8666f751332" => :high_sierra
    sha256 "c679e86562b81e82ba77616e7d28a034095607ff749defd31cf1292ec5752c1c" => :sierra
    sha256 "ca7a8914c17f071efb9a4b1a99d861827a1ea7eb2903df10e4bf485f3a525566" => :el_capitan
  end

  devel do
    url "https://tor.eff.org/dist/tor-0.3.2.2-alpha.tar.gz"
    mirror "https://www.torproject.org/dist/tor-0.3.2.2-alpha.tar.gz"
    sha256 "948f82246370eadf2d52a5d1797fa8966e5238d28de5ec69120407f22d59e774"
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

  def plist; <<-EOS.undent
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
