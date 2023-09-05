class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.4/transmission-4.0.4.tar.xz"
  sha256 "15f7b4318fdfbffb19aa8d9a6b0fd89348e6ef1e86baa21a0806ffd1893bd5a6"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "2d18e18ebe86099c28f54e52b65298dee08c2b15e27e5da55d9fc22d48d8fb5c"
    sha256 arm64_monterey: "c091904f20f6900a2d7a5d6961ed8f0395df55fc6850a37fdd613df687ac866a"
    sha256 arm64_big_sur:  "0ee9fffb0688c0c17032d523ea259bc1f764ca8a76c7f45c74264a9c0a2fa892"
    sha256 ventura:        "4119abd510ecb09ae2bb8d6f219a9bfd184646828311ab0e0376faf6c1881185"
    sha256 monterey:       "6385516eca0968a00d70e0260a474255d30ea7b27dac220f57d1e1e31703bdf4"
    sha256 big_sur:        "bdcae7f5ce8d74ae62e0416b391b554a8ba437d3bc376be3edb501164706905b"
    sha256 x86_64_linux:   "842279283b40e40d5878b346808a263eb1e6ab180abd5b4afd7fedc9e6300ba4"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
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
