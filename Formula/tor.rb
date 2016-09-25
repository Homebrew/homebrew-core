class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.8.8.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.8.8.tar.gz"
  sha256 "b1af02c61253dcdb4e1a4f552adaba4e07aed0e5468e45c0764550161480e3de"

  bottle do
    sha256 "93a8d7409aca9338a8ffe958630aa39cae38091af08e6555b3c960a1c402880a" => :sierra
    sha256 "f5ce09915016ee76cc94bfd051149cbd951d1104e7046312652b7cd91aa4189a" => :el_capitan
    sha256 "4dd87eaf4d77ccf0e70859d844f4e39090abc05de83c098bd72a60ae971cf749" => :yosemite
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.9.3-alpha.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.9.3-alpha.tar.gz"
    sha256 "ee51f62191a33b2b3f50a2cf691dd6250fd0c110f97b8360785a1b56be5eee15"
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
