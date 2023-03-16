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
    sha256 arm64_ventura:  "98802b194c66798d671f9bca130fe68e29bfa6f100af050cf8c42b7abc31d557"
    sha256 arm64_monterey: "2226b75355904336981e73bb27bd6ee188599881a9b5dda270508bdcfb90f675"
    sha256 arm64_big_sur:  "7c157dce0f5339e4317b2727929f5e6370ceb95e38ea6eca1d48e9fef4433dd0"
    sha256 ventura:        "816a1d500c494ec4254b52a66bfcd7396c6087eef95bd6fa7c1e2f2224f7e6c9"
    sha256 monterey:       "bdfa6a52225c03bab3cca6679ca9402d6b1e06595610cf1f4d1fa68fef6c94a2"
    sha256 big_sur:        "50707dba2364185f0707fcfd61aef888a9d85f5cd1abc66335aedda7402b984e"
    sha256 x86_64_linux:   "86f5b5d6520beb7297fe400b5f2c412b4cd54435f5692d06155a7fef67e829d7"
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
