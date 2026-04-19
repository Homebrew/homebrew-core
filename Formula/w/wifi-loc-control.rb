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

  test do
    ENV["HOME"] = testpath
    (testpath/"Library/Logs").mkpath

    (testpath/"bin").mkpath

    (testpath/"bin/networksetup").write <<~EOS
      #!/bin/sh
      echo "Preferred networks on en0:"
      echo "TestSSID"
    EOS

    (testpath/"bin/scselect").write <<~EOS
      #!/bin/sh
      echo "$*" >> "#{testpath}/scselect_calls"
      if [ "$#" -eq 0 ]; then
        echo " * Work (Work)"
        echo " Automatic (Automatic)"
      else
        echo "$1" > "#{testpath}/switched_location"
      fi
    EOS

    (testpath/"bin/sleep").write <<~EOS
      #!/bin/sh
      exit 0
    EOS

    %w[networksetup scselect sleep].each do |file|
      chmod 0755, testpath/"bin/#{file}"
    end
    ENV.prepend_path "PATH", testpath/"bin"

    system bin/"wifi-loc-control"

    assert_path_exists testpath/"switched_location"
    assert_equal "Automatic", (testpath/"switched_location").read.strip
    assert_match "Automatic", (testpath/"scselect_calls").read
    assert_match "location switched to 'Automatic'", (testpath/"Library/Logs/WiFiLocControl.log").read
  end
end
