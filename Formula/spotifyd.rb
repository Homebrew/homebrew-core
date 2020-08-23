class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"
  url "https://github.com/Spotifyd/spotifyd/archive/v0.2.24.tar.gz"
  sha256 "d3763f4647217a8f98ee938b50e141d67a5f3d33e9378894fde2a92c9845ef80"
  license "GPL-3.0"
  head "https://github.com/Spotifyd/spotifyd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f51d6a45bdb965dcc88e34411949006b21050b7dfde5482e46cc6d74de41fa8" => :catalina
    sha256 "c8ab59ca503c0cc84a1d684950be2e40db6bffc9f4392a686852fe10f0e3137c" => :mojave
    sha256 "10b06d3fd2aaab659a75eb67170cd0e54f81830b3ebd4b7a65d1bcf7dce17570" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "dbus"

  def install
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
