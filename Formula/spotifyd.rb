class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"
  url "https://github.com/Spotifyd/spotifyd/archive/v0.2.25.tar.gz"
  sha256 "67dc4ef97a4a3ffcfb137b0409e4428ff9b9ace49d9fdd5cbc216e147edbf925"
  license "GPL-3.0-only"
  head "https://github.com/Spotifyd/spotifyd.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5b5f8cae3d600eb6aee6ac3ac9ccdd036d37308820e2ac11b9b49bcd2ae41983" => :big_sur
    sha256 "e86e0a3ece83eccdfecfd584b4a6dea2682c857b766945821dfbf792370540de" => :catalina
    sha256 "d7e0da5e772657ce9cbdb3a6f48aa47cc55a87b563913f957cf35ba678814991" => :mojave
    sha256 "d745753724407c3b7e1d88743c4abfac7c1c945a9f03608dc7be4d90f1878bd0" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "dbus"

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features=dbus_keyring,rodio_backend",
                               *std_cargo_args
  end

  def caveats
    <<~EOS
      Configure spotifyd using these instructions:
        https://github.com/Spotifyd/spotifyd#configuration-file
    EOS
  end

  plist_options manual: "spotifyd --no-daemon"

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
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    cmd = "#{bin}/spotifyd --username homebrew_fake_user_for_testing --password homebrew --no-daemon --backend rodio"
    assert_match /Authentication failed/, shell_output(cmd, 101)
  end
end
