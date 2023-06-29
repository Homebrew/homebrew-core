class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.3/transmission-4.0.3.tar.xz"
  sha256 "b6b01fd58e42bb14f7aba0253db932ced050fcd2bba5d9f8469d77ddd8ad545a"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "8f00b6d3a0b7823ed90dece482d139221b3708e6342a5091d4aba579fd5c607d"
    sha256 arm64_monterey: "387124cbfc9e7be99a56af09d6fea73d8b50bf65cb43eec8c9d431f5baf47343"
    sha256 arm64_big_sur:  "79cc4c6812b55afeb60080090543512960f5c871f99522230cac172df0a2054d"
    sha256 ventura:        "f1a2ff5ce58fe4f8014f6b5adf3b28db638ce5324ebf1a9e04f59b5c4e921b03"
    sha256 monterey:       "43ed6b1befc09da93f0263e2cb704d1988a040ef0866850f63386a0b2d5310b2"
    sha256 big_sur:        "1ce80c38dea2fb6e02cd58ff0e7283bcf87a4a8eb456aae20107b484a01b3d04"
    sha256 x86_64_linux:   "11c6a5a7b5399edb5d1cd175b6c57fde40baf5f2a366d76b994afc97ece0e781"
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
