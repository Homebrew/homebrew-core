class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.6/transmission-4.0.6.tar.xz"
  sha256 "2a38fe6d8a23991680b691c277a335f8875bdeca2b97c6b26b598bc9c7b0c45f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "b9e4113a3030e91fd27c5bbced1e21c7c67261050ff8f11c1a4e173a4f747a04"
    sha256 arm64_sonoma:  "ca4dbdf34346c6bc37192dc9ee53971b265cf9c3fbba6e38339f5766c11fbb15"
    sha256 arm64_ventura: "8176400e94d9c4f5a33034b353021ccc35f55663f8d31f11bbf23ce78123527c"
    sha256 sonoma:        "0237d99f85751e50e87c31577c7903680c5f16051c1541a0b84865bb22e237ec"
    sha256 ventura:       "3268040e7f67f734934bdaa0e7c439bc120c4ba12ac06f345e74b2b633298ae1"
    sha256 arm64_linux:   "6c0d31567892d665e133f24ce529e7dde3fceeaeadcadb776c7d7a18cf77b971"
    sha256 x86_64_linux:  "ef83d1cad5d89e26eea96e4ed7fe42769c94947735ca013fe7b8a8bdc0e007e2"
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
