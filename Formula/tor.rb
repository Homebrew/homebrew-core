class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.8.7.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.8.7.tar.gz"
  sha256 "ae44e2b699e82db7ff318432fd558dfa941ad154e4055f16d208514951742fc6"

  bottle do
    sha256 "61d4930d118f6ffa5c2ce5b81a68f8a6e76df42dd732a3b2edabe9f7403b6150" => :el_capitan
    sha256 "d4fe09c14eae1b909056cc9a258fd1f5e941bf9b07d7d61dd7dc4ef87a1d2c36" => :yosemite
    sha256 "69cd219fde5288ed696ef0c85420b52e9852e7dd15e08a1dfa2dc582ae8a258e" => :mavericks
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.9.2-alpha.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.9.2-alpha.tar.gz"
    version "0.2.9.2-alpha"
    sha256 "dd93cf6b8531acf68152adbfa2f693cebd1b3254bc6190c920a99cc587944922"
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

  def caveats; <<-EOS.undent
    You will find a sample `torrc` file in #{etc}/tor.
    It is advisable to edit the sample `torrc` to suit
    your own security needs:
      https://www.torproject.org/docs/faq#torrc
    After editing the `torrc` you need to restart tor.
    EOS
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
    assert (testpath/"authority_certificate").exist?
    assert (testpath/"authority_signing_key").exist?
    assert (testpath/"authority_identity_key").exist?
  end
end
