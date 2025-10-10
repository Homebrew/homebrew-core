class WifiLocControl < Formula
  desc "Change macOS network location based on the Wi-Fi network name (SSID)"
  homepage "https://github.com/vborodulin/wifi-loc-control"
  url "https://github.com/vborodulin/wifi-loc-control/archive/refs/tags/1.0.5.tar.gz"
  sha256 "13ef3b7611d519a1c5772432b64355c35d45df03af43e9afd260430d309664b6"
  license "MIT"

  depends_on :macos

  def install
    bin.install "wifi-loc-control.sh" => "wifi-loc-control"

    # Modify the Program Path to brew installed one
    inreplace "WifiLocControl.plist", "/usr/local/bin/wifi-loc-control.sh", bin/"wifi-loc-control"

    # Install the plist file
    prefix.install "WifiLocControl.plist" => "application.com.wifi-loc-control.plist"
  end

  service do
    name macos: "application.com.wifi-loc-control"
  end

  def caveats
    <<~EOS
      To start wifi-loc-control now and restart at login:
        brew services start wifi-loc-control
    EOS
  end

  test do
    assert_predicate bin/"wifi-loc-control", :executable?
    assert_path_exists prefix/"application.com.wifi-loc-control.plist"
  end
end
