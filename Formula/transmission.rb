class Transmission < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission-releases/raw/dc77bea/transmission-2.94.tar.xz"
  sha256 "35442cc849f91f8df982c3d0d479d650c6ca19310a994eccdaa79a4af3916b7d"

  bottle do
    rebuild 1
    sha256 "2a7d6cb307a817eed5a02bab0dcfbb2d024d626bd768116d5107ef74a79282a5" => :mojave
    sha256 "6aa06621a0754c3a2f76572f68f0992747b4b2240e7424795f63071bfab5475b" => :high_sierra
    sha256 "57ec396481d8107933552649d46de6ec78aaaa6c3a80ab27d1ba2a9465925471" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  def install
    ENV.append "LDFLAGS", "-framework Foundation -prebind"
    ENV.append "LDFLAGS", "-liconv"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-mac
      --disable-nls
      --without-gtk
    ]

    system "./configure", *args
    system "make", "install"

    (var/"transmission").mkpath
  end

  def caveats; <<~EOS
    This formula only installs the command line utilities.

    Transmission.app can be downloaded directly from the website:
      https://www.transmissionbt.com/

    Alternatively, install with Homebrew Cask:
      brew cask install transmission
  EOS
  end

  plist_options :manual => "transmission-daemon --foreground"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/transmission-daemon</string>
          <string>--foreground</string>
          <string>--config-dir</string>
          <string>#{var}/transmission/</string>
          <string>--log-info</string>
          <string>--logfile</string>
          <string>#{var}/transmission/transmission-daemon.log</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/transmission-create", "-o", "#{testpath}/test.mp3.torrent", test_fixtures("test.mp3")
    assert_match /^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent")
  end
end
