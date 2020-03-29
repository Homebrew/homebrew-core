class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission-releases/raw/dc77bea/transmission-2.94.tar.xz"
  sha256 "35442cc849f91f8df982c3d0d479d650c6ca19310a994eccdaa79a4af3916b7d"
  revision 2

  bottle do
    sha256 "9b8fbc3736ab6996736d0d53622f4e05399db8f53d3f8323c8d203d84886e753" => :catalina
    sha256 "2bba4f2cf7ffde53a658897f3855100ae0e3b795f231ed33a06eb9941b90793b" => :mojave
    sha256 "2e81c3beb940cf1d8ffe15fcfea9361109ba2538fb176f91a4f51da8824bf24c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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

  def caveats
    <<~EOS
      This formula only installs the command line utilities.

      Transmission.app can be downloaded directly from the website:
        https://www.transmissionbt.com/

      Alternatively, install with Homebrew Cask:
        brew cask install transmission
    EOS
  end

  plist_options :manual => "transmission-daemon --foreground"

  def plist
    <<~EOS
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
