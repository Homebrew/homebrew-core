class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.6/transmission-4.0.6.tar.xz"
  sha256 "2a38fe6d8a23991680b691c277a335f8875bdeca2b97c6b26b598bc9c7b0c45f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "94d02b7c2b45b7450c52829a5ab321326233bfbed68dbfd893c8baff83fd0a0b"
    sha256 arm64_sonoma:   "0f0903287fe52ce1b88eed158aae216a75bdf0ab494d5e99f295b65c411820cc"
    sha256 arm64_ventura:  "4805411462de5ffd0816e57000adb672d111babf25e7e0776724e28063bbad1c"
    sha256 arm64_monterey: "b1337b3c899974f389a87b82fdc534bfa3bfbdc084287bfb922424345d2cf870"
    sha256 sonoma:         "e21900a4d0aca80c877027429c58988a95a57c690bee3b82e8d851b0d2b6b7d6"
    sha256 ventura:        "2d3bfe4e50fa99d891cfd8271e41a4be8382833046e17a500e1ddc835c5a8059"
    sha256 monterey:       "9a05cac7b4b68b0d327e78a8904ead9ca46221fadb7cd340cdf9b3315d85e98b"
    sha256 x86_64_linux:   "2385b33a24c9f11c58274d956f42dee8e2ad66ef1cc849934f36e433250f90f3"
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
