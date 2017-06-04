class Transmission < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission-releases/raw/094777d/transmission-2.92.tar.xz"
  sha256 "3a8d045c306ad9acb7bf81126939b9594553a388482efa0ec1bfb67b22acd35f"
  revision 1

  bottle do
    sha256 "28ee6ef92d3c75e664eff438e08c66a26645fd27f308ef58839eae676d0e8f06" => :sierra
    sha256 "f82fb7296f36573dd7730b602edcf27421d880cd8e3c16a56a69c1503d26a5e0" => :el_capitan
    sha256 "e1b7d0f5ed6928752c71898e92364209e28a3c6d6e4be01572f818b852f57e37" => :yosemite
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

  def caveats; <<-EOS.undent
    This formula only installs the command line utilities.

    Transmission.app can be downloaded directly from the website:
      https://www.transmissionbt.com/

    Alternatively, install with Homebrew-Cask:
      brew cask install transmission
    EOS
  end

  plist_options :manual => "transmission-daemon --foreground"

  def plist; <<-EOS.undent
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
