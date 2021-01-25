class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.22.5",
      revision: "6c653ab268df2ef36618ef7c2060f6744f220632"
  license "MIT"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "727d94aab4640fda5cb99ecb707b51700593611709de97e885de4c2b3add8399" => :big_sur
    sha256 "1dafc31c60acb2fbba10a2a083dfae90ca02fee4adaa55c1f07929902ca0b6de" => :arm64_big_sur
    sha256 "e9b1e4e676eba3b71f4e7462c4c90a0b06750c3983624bc60a2c5b30ba552ebf" => :catalina
    sha256 "65277f9a0667a46aafc4fd49224b089fab8fe335c807cd778df3ea4cb7b4685d" => :mojave
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{Utils.git_short_head}
    ]

    system "go", "build", "-o", bin/"tile38-server", "-ldflags", ldflags.join(" "), "./cmd/tile38-server"
    system "go", "build", "-o", bin/"tile38-cli", "-ldflags", ldflags.join(" "), "./cmd/tile38-cli"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats
    <<~EOS
      To connect: tile38-cli
    EOS
  end

  plist_options manual: "tile38-server -d #{HOMEBREW_PREFIX}/var/tile38/data"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/tile38-server</string>
            <string>-d</string>
            <string>#{datadir}</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/tile38.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/tile38.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/tile38-server", "-q"
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli server").lines[1]
    tile38_server = JSON.parse(json_output)
    assert_equal tile38_server["ok"], true
  ensure
    Process.kill("HUP", pid)
  end
end
