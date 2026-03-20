class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.1.1/transmission-4.1.1.tar.xz"
  sha256 "e743283ee03a42c4d0b08fed2bd52b554aa6c9f65b4d4d45b795c32d98762a79"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "fe9261335dbea9b764860e7f7896c130224e8303c5531396c4c7ed10169c3e80"
    sha256 arm64_sequoia: "997dba537fe42c31fe13aeadfe1c5b5916a8e4908d1712261ce9ac0cba98fabb"
    sha256 arm64_sonoma:  "5ce3057c3dbefc13502befd6def3826b118441d3680010a94460df0502e0e4fb"
    sha256 sonoma:        "416b077bc874b0cb0a5da08a14162401d6edae76bf23c15e78fbd218d965fa82"
    sha256 arm64_linux:   "54110a1b36c0687ce75ff829bb125bb338790574bbc13a5412552f20523b7261"
    sha256 x86_64_linux:  "48925f46cf3a75f1538b3860fc126eee79b69a56858c7a33f78af872aa56b82b"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
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
