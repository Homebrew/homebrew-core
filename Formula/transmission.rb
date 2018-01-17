class Transmission < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission-releases/raw/094777d/transmission-2.92.tar.xz"
  sha256 "3a8d045c306ad9acb7bf81126939b9594553a388482efa0ec1bfb67b22acd35f"
  revision 2

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/cf09cf8/transmission/CVE-2018-5702.patch"
    sha256 "a28016143b94a07c225799a6e0e473657b56fd1f346b04537eca4dc37ffab8a9"
  end

  bottle do
    sha256 "10c8ab080a30f20bf2a777d71cecf5efdddbbf5ff99f8d1547ec6d1af892083a" => :high_sierra
    sha256 "d92ff97c980b5b21f9a339add298a3c891ff899bd46c6875d5b082c99be5412b" => :sierra
    sha256 "c899c5ae9a3041422939940425c5382af3b0f2ab1acac4ffa3a5bd33fc45cbda" => :el_capitan
  end

  option "with-nls", "Build with native language support"

  depends_on "pkg-config" => :build
  depends_on "libevent"

  if build.with? "nls"
    depends_on "intltool" => :build
    depends_on "gettext"
  end

  def install
    ENV.append "LDFLAGS", "-framework Foundation -prebind"
    ENV.append "LDFLAGS", "-liconv"

    args = %W[--disable-dependency-tracking
              --prefix=#{prefix}
              --disable-mac
              --without-gtk]

    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    system "make", "install"

    (var/"transmission").mkpath
  end

  def caveats; <<~EOS
    This formula only installs the command line utilities.

    Transmission.app can be downloaded directly from the website:
      https://www.transmissionbt.com/

    Alternatively, install with Homebrew-Cask:
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
