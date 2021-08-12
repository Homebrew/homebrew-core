class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"
  url "https://github.com/Spotifyd/spotifyd/archive/v0.3.2.tar.gz"
  sha256 "d1d5442e6639cde7fbd390a65335489611eec62a1cfcba99a4aba8e8977a9d9c"
  license "GPL-3.0-only"
  head "https://github.com/Spotifyd/spotifyd.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "e3c99852d97789b09ef67bb82ac9e7a306df83db777bffc048173b4d2583bc4d"
    sha256 cellar: :any,                 big_sur:       "5aadd7c8795f10a8033a0055c1ebea4b1101068b5a89b1ee83efc588121365d3"
    sha256 cellar: :any,                 catalina:      "e0728a13eb91be7b7cfa0da67b19b3d49ec9608b745e6833014e9ff26cb9e51f"
    sha256 cellar: :any,                 mojave:        "6fbf9e30f4501d8642f827f51ba4a610e7888e6156fccda11fab09ba0b6be3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "487542236226aef4efa1e22c5945c39b0af94ad4b367b43107296ba8579a3095"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "dbus"
  depends_on "portaudio"

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features", "dbus_keyring,portaudio_backend",
                               *std_cargo_args
  end

  plist_options manual: "spotifyd --no-daemon --backend portaudio"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ThrottleInterval</key>
          <integer>30</integer>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/spotifyd</string>
              <string>--no-daemon</string>
              <string>--backend</string>
              <string>portaudio</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    cmd = "#{bin}/spotifyd --username homebrew_fake_user_for_testing \
      --password homebrew --no-daemon --backend portaudio"
    assert_match "Authentication failed", shell_output(cmd, 101)
  end
end
