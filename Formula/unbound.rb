class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.13.1.tar.gz"
  sha256 "8504d97b8fc5bd897345c95d116e0ee0ddf8c8ff99590ab2b4bd13278c9f50b8"
  license "BSD-3-Clause"
  head "https://github.com/NLnetLabs/unbound.git"

  # We check the GitHub repo tags instead of
  # https://nlnetlabs.nl/downloads/unbound/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url :head
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "ca8e29b1898957208edd7a8ea445b0d39c942815a57f428b612ff0ae636bf859"
    sha256 big_sur:       "c29ad2474ecb496f9e98a7389485cac2c542d8515d5fd2810bed05f206350a21"
    sha256 catalina:      "0276d7a615cdd250ce1764a708c9e031c9c814f7d2c1a0f7aeb9d08166875af6"
    sha256 mojave:        "27a471fe986b64f4ccd80280ba5695532ec77198542b30f0bd176cb02f07b0b8"
  end

  depends_on "libevent"
  depends_on "nghttp2"
  depends_on "openssl@1.1"

  uses_from_macos "expat"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libnghttp2=#{Formula["nghttp2"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    on_macos do
      args << "--with-libexpat=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed
    end
    on_linux do
      args << "--with-libexpat=#{Formula["expat"].opt_prefix}"
    end
    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "install"
  end

  def post_install
    conf = etc/"unbound/unbound.conf"
    return unless conf.exist?
    return unless conf.read.include?('username: "@@HOMEBREW-UNBOUND-USER@@"')

    inreplace conf, 'username: "@@HOMEBREW-UNBOUND-USER@@"',
                    "username: \"#{ENV["USER"]}\""
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>RunAtLoad</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/unbound</string>
            <string>-d</string>
            <string>-c</string>
            <string>#{etc}/unbound/unbound.conf</string>
          </array>
          <key>UserName</key>
          <string>root</string>
          <key>StandardErrorPath</key>
          <string>/dev/null</string>
          <key>StandardOutPath</key>
          <string>/dev/null</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end
