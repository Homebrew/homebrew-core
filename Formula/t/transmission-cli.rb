class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.6/transmission-4.0.6.tar.xz"
  sha256 "2a38fe6d8a23991680b691c277a335f8875bdeca2b97c6b26b598bc9c7b0c45f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "c9845700af335c04b19ad745686b81f1319d3a053050aa46b2e9391a6b8abed8"
    sha256 arm64_ventura:  "031163e2db6eb1efeba956fdade120c1e5809585acbefc3d4bb1d726ab73db55"
    sha256 arm64_monterey: "3d8030fb8b11ed9f376307559670a513b89c2a8afed5a722dd9c298cc1a3191b"
    sha256 sonoma:         "6a03d5e56959885f0ef4ed70f7e2458872dc73ebfd7a8a453c48c823590f2e48"
    sha256 ventura:        "819c55421848c5c1ec7c3c98d50c5979dde4ab46f5f7b60904ce7defb0e143e4"
    sha256 monterey:       "dd65e137bd9ea870d2d8a10bd13f228a2d99f328f5a8ed655708c275eaa011a6"
    sha256 x86_64_linux:   "bda1756578cf7016945cc9144cc04254a86c0ebcfe46d7c361e0892e99854719"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "miniupnpc"

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
    system bin/"transmission-create", "-o", testpath/"test.mp3.torrent", test_fixtures("test.mp3")
    assert_match(/^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent"))
  end
end
