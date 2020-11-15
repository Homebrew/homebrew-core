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
    sha256 "85923e2089910ad3212bcb59f9f5bde647a32d02f4b88419fd1b02736381b43e" => :big_sur
    sha256 "79aeb69314b4130ecfc3123bd34a425be5a8e9a89a97fb4efbdb9b1ce73aca7e" => :catalina
    sha256 "904be653cf0e2fb3e7680f711288c0bba4cbe762b9dba8133796431ef2228d57" => :mojave
    sha256 "3241af3dbfee60533efc5740897ecec05433789f3bcb9c92bd0c64bcd2481abb" => :high_sierra
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
