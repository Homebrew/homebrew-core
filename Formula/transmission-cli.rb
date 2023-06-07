class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.3/transmission-4.0.3.tar.xz"
  sha256 "b6b01fd58e42bb14f7aba0253db932ced050fcd2bba5d9f8469d77ddd8ad545a"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "3c86f43d0a7ed493583a9e02991cdf797ccb95b2427dd6e220ab19189e628795"
    sha256 arm64_monterey: "2d9e2b36c818bbb771e5d3a16bf97688766f2af0f6f4a2b54d9c056e99d80bdd"
    sha256 arm64_big_sur:  "5c4174d5fcba66fc24e5db9519a2a71c32046a221d4bcfe11744d2faceb6dcc0"
    sha256 ventura:        "86f5a1daacc2da1a0dc0a84856a2dd39abb6af0a1764ecf320e96fab5fdbd8fc"
    sha256 monterey:       "f95f169b4f5207d352fa7a9b0ab3c74010a624846e7568f2000f7249235766d4"
    sha256 big_sur:        "0659655e456ffa00d68cea154f38c2821f058c3ef896725856c7742eb69f8ea4"
    sha256 x86_64_linux:   "4a7775ae15acbcf3c612da6222021b54834a2ce5b753ed117e17de6406882c4d"
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
