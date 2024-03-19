class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.5/transmission-4.0.5.tar.xz"
  sha256 "fd68ff114a479200043c30c7e69dba4c1932f7af36ca4c5b5d2edcb5866e6357"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "b5e9657b1b68418730b83241402e4cd920e1435d486c0e808112604144abfb89"
    sha256 arm64_ventura:  "486256bd49bb056fdfed7be6410250b944422a851caf5e0c23c6b0222beceeac"
    sha256 arm64_monterey: "25a97b33cea73fe451481caf4e230624c4c426d36bdd7289e5055182c8c6333f"
    sha256 sonoma:         "8e2546700b358f34d1a29783fb4eb860bf996a9393acecad9d5fb30ce8d618b9"
    sha256 ventura:        "57be8ac8a7e8fa483ab0ad0c8eee13304ccfdbe9c2614061faa1f23cf7a23ca3"
    sha256 monterey:       "bf81a29ab61299f7b1706bb6491d2896412b64b6f02217fdaa88c54769b8b002"
    sha256 x86_64_linux:   "452e7344e8cebd8278636938b78bbb303acafb6ff5aa6f4f0c9f12db20c2b9c8"
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
