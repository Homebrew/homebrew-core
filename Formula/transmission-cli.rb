class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission-releases/raw/d5ccf14/transmission-3.00.tar.xz"
  sha256 "9144652fe742f7f7dd6657716e378da60b751aaeda8bef8344b3eefc4db255f2"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://github.com/transmission/transmission-releases/"
    strategy :page_match
    regex(/href=.*?transmission[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "bf01d43e836a7108c64716df7acdcbbf7b7734e5bb7f10af10e3f276e450b225"
    sha256 big_sur:       "b0a5765570ae2796c9c5fd7ab2272bb0b6b4add34d85894c99bad77aa38e81da"
    sha256 catalina:      "576f0f5017a86da149292b6da4fde251ad7a77bd9a88e82639ed4fc586cb08e7"
    sha256 mojave:        "d56c90e32e206cdcf5ec8591fcb79de80c9b41483946c354fac4b9f09020c236"
    sha256 high_sierra:   "d8ded603c8aae8b4eaf59c1c078dfdfb44b97191d4ce42439f6b02984ccf16b3"
    sha256 x86_64_linux:  "4e4682f6732b975fce4e9d5b6d98b526ab4a31c272f5600d46708048bded5df9"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    on_macos do
      ENV.append "LDFLAGS", "-framework Foundation -prebind"
      ENV.append "LDFLAGS", "-liconv"
    end

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
        brew install --cask transmission
    EOS
  end

  service do
    run [opt_bin/"transmission-daemon", "--foreground", "--config-dir", var/"transmission/", "--log-info",
         "--logfile", var/"transmission/transmission-daemon.log"]
    keep_alive true
  end

  test do
    system "#{bin}/transmission-create", "-o", "#{testpath}/test.mp3.torrent", test_fixtures("test.mp3")
    assert_match(/^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent"))
  end
end
