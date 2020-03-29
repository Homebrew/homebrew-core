class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.2.7.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.2.7.tar.gz"
  sha256 "06a1d835ddf382f6bca40a62e8fb40b71b2f73d56f0d53523c8bd5caf9b3026d"

  bottle do
    sha256 "e66d5fd20255c03d532cec0c31e750b81c93e048bf3ae0f88bc787578a2844e4" => :catalina
    sha256 "fbf0241e0cead767d2b977c43c56e39492ad0159dbe647b119e0dc47eb6a4f91" => :mojave
    sha256 "2e97cc960eae30d69030b9cb577342eda531350bb65eba35571fb30be7cae6ae" => :high_sierra
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
