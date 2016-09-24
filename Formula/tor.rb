class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.8.7.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.8.7.tar.gz"
  sha256 "ae44e2b699e82db7ff318432fd558dfa941ad154e4055f16d208514951742fc6"

  bottle do
    sha256 "975fccef55da03bd6e907d6e68f50a3f3d8b9e8e8f0152f2c8fba02499758d87" => :sierra
    sha256 "b843a3e96a0c7222d98989770f4516d35cbae6e2c5038a56c430cd69d1bd6044" => :el_capitan
    sha256 "3557e5d503dff2764b118ba5e5461918886a3d418161eb9ee8360e08869bab82" => :yosemite
    sha256 "fd22b9bc52efa6579abfd0cd0ba3b7901064bf73a990ed1923033f5a497a1308" => :mavericks
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
