class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.8.9.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.8.9.tar.gz"
  sha256 "3f5c273bb887be4aff11f4d99b9e2e52d293b81ff4f6302b730161ff16dc5316"

  bottle do
    sha256 "416c7aae92cdfa1eeca94cd9bdd7ddcdd369035df1719812a15bab364fba9573" => :sierra
    sha256 "a01b47d919213a3d6a26a08b61003c12468bf4c44b3cad06811964667d28a908" => :el_capitan
    sha256 "fa8590ea32441029f8b8e6c043154b9f60710af2bd505b891708c6a3cb75c5e2" => :yosemite
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.9.4-alpha.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.9.4-alpha.tar.gz"
    sha256 "fc5664fff4c86d3644043a068f11b17c57f9a295c37b7186bf90bb237913e400"
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
