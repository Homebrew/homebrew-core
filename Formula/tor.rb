class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"

  stable do
    url "https://dist.torproject.org/tor-0.2.7.6.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.7.6.tar.gz"
    sha256 "493a8679f904503048114aca6467faef56861206bab8283d858f37141d95105d"

    # autotools only needed as long as the patch below is applied;
    # remove them when the patch goes away
    depends_on "autoconf" => :build
    depends_on "automake" => :build

    # Fixes build on 10.12
    # https://trac.torproject.org/projects/tor/ticket/17819
    # Applied upstream, will be in the next release.
    patch do
      url "https://trac.torproject.org/projects/tor/raw-attachment/ticket/17819/pthread.diff"
      sha256 "9eb64548f0c1efae28535dcfa4ed19824eccaea1cee62607adb480b99217697b"
    end
  end

  bottle do
    sha256 "32bb77890419cef8b2152e9a6cd554b71021baa64d3dac8fc8d48d7d24d51e99" => :el_capitan
    sha256 "a3edf9af56c01b70f582ca4d4ddb552274b876db7922c0494407804f3877975b" => :yosemite
    sha256 "595d64e121de2417e647d5c8a1d0051d5a3e3de9c0e15429134c5dd494459573" => :mavericks
  end

  stable do
    # autotools only needed as long as the patch below is applied;
    # remove them when the patch goes away
    depends_on "autoconf" => :build
    depends_on "automake" => :build

    # Fixes build on 10.12
    # https://trac.torproject.org/projects/tor/ticket/17819
    # Applied upstream, will be in the next release.
    patch do
      url "https://trac.torproject.org/projects/tor/raw-attachment/ticket/17819/pthread.diff"
      sha256 "9eb64548f0c1efae28535dcfa4ed19824eccaea1cee62607adb480b99217697b"
    end
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.8.4-rc.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.8.4-rc.tar.gz"
    version "0.2.8.4-rc"
    sha256 "3070015123094bf576641a34aaf4cec17f548f0108447031445d42cae164f6ba"
  end

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

  plist_options :manual => "tor start"

  test do
    pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    assert (testpath/"authority_certificate").exist?
    assert (testpath/"authority_signing_key").exist?
    assert (testpath/"authority_identity_key").exist?
  end

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
end
