class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"
  url "https://github.com/Spotifyd/spotifyd/archive/v0.3.0.tar.gz"
  sha256 "47b3d9a87a9bc8ff5a46b9ba3ccb5ea0b305964c6f334e601a0316697d8bcd4a"
  license "GPL-3.0-only"
  head "https://github.com/Spotifyd/spotifyd.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "fdc3e5aeee7705fad20e9c5278d21a2e0590d622ec929494ecc2eaed7220a6f9"
    sha256 cellar: :any_skip_relocation, catalina: "ce40421f0813e1652b241385eabffe4c06f1fce26de182f36907a739e38b14b3"
    sha256 cellar: :any_skip_relocation, mojave:   "4c0ad2cabb7962b0f798c74fc0d6246c4b430b2350e5672b1a23a89efc981cd9"
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
