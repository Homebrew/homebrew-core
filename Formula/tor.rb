class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.8.10.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.8.10.tar.gz"
  sha256 "c88b8c57b34ebf44b731df5d68f73eb6b6708bcf4e42cf7b4817fd4e304c9c4d"

  bottle do
    sha256 "cc8d68557dcfaef7f21a190716d6c1ff4bfd101b461459f9842d997bceb822b2" => :sierra
    sha256 "59fa77602b0aca4e28b54c8a1a0fce663cfbd0d79d45734c488f8136f3b39acc" => :el_capitan
    sha256 "e629e19eb35307b5897918f425f2fd42e3e1f2236b2417b3489951e4f5b6b50f" => :yosemite
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.2.9.6-rc.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.9.6-rc.tar.gz"
    sha256 "871ba289c87ffec99ada458083f388ba5b81c6174ba0c6f821eb9a08ed4990bb"
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
