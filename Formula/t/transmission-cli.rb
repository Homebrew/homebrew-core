class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.0.6/transmission-4.0.6.tar.xz"
  sha256 "2a38fe6d8a23991680b691c277a335f8875bdeca2b97c6b26b598bc9c7b0c45f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "25ddc150f211ccc39b47eb5d45659b61f104ae2d777f7980ca19732abb9a2fb9"
    sha256 arm64_sequoia: "542c4fe40c57c427680eb5a982e0a6437bbaa9adac9b174fcb5f9fc5cf98dffe"
    sha256 arm64_sonoma:  "2e13ac5fce4a74345d5e02ae860fea0b05c7d6fbe7f94a448d14a121d9586fea"
    sha256 arm64_ventura: "61e957019a73bb95a8805af721ce6b7f9f9acdc30c6bc8a65ab0b47b273f869b"
    sha256 sonoma:        "498982b372e53a61addf98d76169e5c01851d89bce7b70bc3915894f184ca558"
    sha256 ventura:       "f25b459d033bdf9842d66e09ec65989a0336caca52b195206b6dfaf39cd9ee6d"
    sha256 arm64_linux:   "a34e16ce8d16148d11ff1eedca2ba0bbfa45a5942a272d281d88d9936be05290"
    sha256 x86_64_linux:  "d05e4a68c07c6fa2b73df241d91d566d6af0e5ea0008cdc360ad6e65d7379624"
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
    odie "Remove cmake 4 build patch" if build.stable? && version > "4.0.6"

    # CMake 4 compatibility for third-parties of miniupnpc
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

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
