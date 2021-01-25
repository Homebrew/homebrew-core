class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.4.6.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.4.6.tar.gz"
  sha256 "5f154c155803adf5c89e87cab53017b6908c5ebe50c65839e8cf4fbd2abe1fdc"

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "345a31685faa4b551c32ea7265191ef71db9dc90ab41af189535b831b6877f47" => :big_sur
    sha256 "652dd8e0b2154d100747672e64eb45b2a7ffd9c9117b1f17a29df537d15f1f28" => :arm64_big_sur
    sha256 "a6f0a222f1ce3670521392887eea1b491f4cefa8031e1cea7e2e33dea93d715b" => :catalina
    sha256 "cc4678fc4cdf9a93cb5dc7f10a02df0e1bd950becd2b944afad59b7d64bbad3b" => :mojave
    sha256 "52937701615bbe2ec97bdccd6dcd287a095f20128fc574fff1bfe04d775dac4a" => :high_sierra
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

  plist_options manual: "tor"

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
