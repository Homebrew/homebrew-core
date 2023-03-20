class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.2/transmission-4.0.2.tar.xz"
  sha256 "39bf7a104a722805a9dc089cdaaffe33bf90b82230a7ea7f340cae59f00a2ee8"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "cb6c77e2310ec184abc329f7ee10769fe94e73dd1bee681dc0adb1bb39147daa"
    sha256 arm64_monterey: "96821a7f331ff397706b1d661d7160164b47df41a72e7504f6b67a3ffa4c119e"
    sha256 arm64_big_sur:  "f2ca7e6a1c6cf4d692bcc22d2c5fc1adf0569882b4044ebf7befe4839aa6cb77"
    sha256 ventura:        "06871e866e743ae99e3ae242ddb2ef8b055bf9e8434b0a2d4d0d24bba9a7d6de"
    sha256 monterey:       "4bd05721254b1482d08ae061af18690e73e50283378b4239804f5e5fd533aa48"
    sha256 big_sur:        "759fb23d07dabf7761c1dce899a29afd352eb238c98b8c76bb4922797ee838fb"
    sha256 x86_64_linux:   "a1ac1bf4925a6aed7a7f8892160d3cfb2618d22ae17b8f299a6f74fb6805eff6"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
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
    system "#{bin}/transmission-create", "-o", "#{testpath}/test.mp3.torrent", test_fixtures("test.mp3")
    assert_match(/^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent"))
  end
end
