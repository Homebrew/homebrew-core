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
    sha256 cellar: :any_skip_relocation, big_sur:  "c8f63e37af5e61c265e6843f91244dee84cddd37b4c311145f7b8d1c14e429fe"
    sha256 cellar: :any_skip_relocation, catalina: "777337567077e1ca16cffc7784fed7bfea77ea4f58fc42852584ed181ade6ea5"
    sha256 cellar: :any_skip_relocation, mojave:   "eeb3feaaebc725fc35f27d71c9070089a9dc9d042a845d5d4e6ca4c86aeb58ff"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "dbus"
  depends_on "portaudio"

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features=dbus_keyring,portaudio_backend",
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
