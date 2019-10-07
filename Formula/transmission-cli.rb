class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission-releases/raw/dc77bea/transmission-2.94.tar.xz"
  sha256 "35442cc849f91f8df982c3d0d479d650c6ca19310a994eccdaa79a4af3916b7d"
  revision 1

  bottle do
    sha256 "e64cb28206f2592f2b4b922a5953d6cdc806ec1eb0e20ecf16dbfa333268edcb" => :catalina
    sha256 "83eb7e06a8c621224c883d220ef242127ee4f273cbfa290889118ceb1e4d2cca" => :mojave
    sha256 "800441903403efd301a0a8fc63771523302c43c8020381b4b19cba5ae51da843" => :high_sierra
    sha256 "1f518eddc8e93cd916313a16a0e253f9abe744c45d908bfee5fac40a0d6041f1" => :sierra
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
