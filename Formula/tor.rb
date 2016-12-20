class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.9.8.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.9.8.tar.gz"
  sha256 "fbdd33d3384574297b88744622382008d1e0f9ddd300d330746c464b7a7d746a"

  bottle do
    sha256 "0704cc9e3efbbe5e22cf3bf1591b9d568d36eec1e552478cea0ebf617f225de2" => :sierra
    sha256 "5c5db143efeaddf99ab7e07377ae0098990844750299e1f109b2f624b3949aed" => :el_capitan
    sha256 "923c26a3d5935f061b17adca6091ae95c36b057233a064a0112d0a08db3d9c27" => :yosemite
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.0.1-alpha.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.3.0.1-alpha.tar.gz"
    sha256 "7013353f0cbd2af8c0144f6167339f6eb252eb35ca9a2db2971310171108b064"
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
