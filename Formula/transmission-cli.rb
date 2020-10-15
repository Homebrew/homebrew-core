class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission-releases/raw/d5ccf14/transmission-3.00.tar.xz"
  sha256 "9144652fe742f7f7dd6657716e378da60b751aaeda8bef8344b3eefc4db255f2"
  # license ["GPL-2.0", "GPL-3.0"] - pending https://github.com/Homebrew/brew/pull/7953
  license "GPL-2.0"

  livecheck do
    url "https://github.com/transmission/transmission-releases/"
    regex(/href=.*?transmission[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "576f0f5017a86da149292b6da4fde251ad7a77bd9a88e82639ed4fc586cb08e7" => :catalina
    sha256 "d56c90e32e206cdcf5ec8591fcb79de80c9b41483946c354fac4b9f09020c236" => :mojave
    sha256 "d8ded603c8aae8b4eaf59c1c078dfdfb44b97191d4ce42439f6b02984ccf16b3" => :high_sierra
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

  plist_options manual: "transmission-daemon --foreground"

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
