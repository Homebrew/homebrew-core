class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.1.3/transmission-4.1.3.tar.xz"
  sha256 "ce7d2d8b101f7eb54bc3cf0bc55f52f7ebd4a25fa48e00bdca9a7e0fc02617da"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "a86cf8ff4b7e410a4a425d25a755b42a63a4f66fc705d9b949f7ab5a32a10da8"
    sha256 arm64_sequoia: "f41d28ab18aeef94caace9eb08860e127c92ae939f2cb68b35701e9f69ac0743"
    sha256 arm64_sonoma:  "8007dc63413ea7624d89c28d2ad58dd5d0e3a07d074041e249b71765086a2484"
    sha256 sonoma:        "1a1db00f6da2d16a2d6a8c47b638b3f44de9791c9ccb80e84a1ad61b239dd361"
    sha256 arm64_linux:   "2d179322f917e733098066db8705c4ca5e552a35b2537634a4ee878136600af2"
    sha256 x86_64_linux:  "eaa2633e4f06cbcc683d52b8ce2fcf9ead1c2073d31c8100aa0b332d6992780b"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libpsl"
  depends_on "miniupnpc"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DENABLE_CLI=ON
      -DENABLE_DAEMON=ON
      -DENABLE_MAC=OFF
      -DENABLE_NLS=OFF
      -DENABLE_QT=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_UTILS=ON
      -DENABLE_WEB=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
    system bin/"transmission-create", "-o", testpath/"test.mp3.torrent", test_fixtures("test.mp3")
    assert_match(/^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent"))
  end
end
