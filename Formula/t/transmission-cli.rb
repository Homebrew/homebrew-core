class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.6/transmission-4.0.6.tar.xz"
  sha256 "2a38fe6d8a23991680b691c277a335f8875bdeca2b97c6b26b598bc9c7b0c45f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "ae8206cd8a14489774e7bf2581d7e0ab55c2b5868d7667be203a69f76cf4b631"
    sha256 arm64_sonoma:  "0520fc63dc94fb29d64eec122c55903ef45f2ada76d1e6c732da8ced05f3cce1"
    sha256 arm64_ventura: "a516aea8e739d2e38cc2378ee5fe5e18ee8a1c676d8254ea5cea32cb2196c3e2"
    sha256 sonoma:        "2a49dc19a425a257071fa3dbebfaf2cc53dbbb49c58f6eefd37f463793f47a57"
    sha256 ventura:       "50466452e65aa64a5d3272b76e0c728f60396c69f025357f949ed22c55fae994"
    sha256 x86_64_linux:  "ffb3eef78632cc6ab975c547536163e0ddd6b7620c7bc76b9b040bcba13efacd"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "miniupnpc"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
  end

  # miniupnpc 2.2.8 compatibility patch
  patch :DATA

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

__END__
diff --git a/libtransmission/port-forwarding-upnp.cc b/libtransmission/port-forwarding-upnp.cc
index 7c4865b..695d43f 100644
--- a/libtransmission/port-forwarding-upnp.cc
+++ b/libtransmission/port-forwarding-upnp.cc
@@ -275,8 +275,13 @@ tr_port_forwarding_state tr_upnpPulse(tr_upnp* handle, tr_port port, bool is_ena
 
         FreeUPNPUrls(&handle->urls);
         auto lanaddr = std::array<char, TR_ADDRSTRLEN>{};
-        if (UPNP_GetValidIGD(devlist, &handle->urls, &handle->data, std::data(lanaddr), std::size(lanaddr) - 1) ==
-            UPNP_IGD_VALID_CONNECTED)
+        if (
+#if (MINIUPNPC_API_VERSION >= 18)
+            UPNP_GetValidIGD(devlist, &handle->urls, &handle->data, std::data(lanaddr), std::size(lanaddr) - 1, nullptr, 0)
+#else
+            UPNP_GetValidIGD(devlist, &handle->urls, &handle->data, std::data(lanaddr), std::size(lanaddr) - 1)
+#endif
+            == UPNP_IGD_VALID_CONNECTED)
         {
             tr_logAddInfo(fmt::format(_("Found Internet Gateway Device '{url}'"), fmt::arg("url", handle->urls.controlURL)));
             tr_logAddInfo(fmt::format(_("Local Address is '{address}'"), fmt::arg("address", lanaddr.data())));
