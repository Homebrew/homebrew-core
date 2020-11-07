class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
    tag:      "1.22.4",
    revision: "dd53091be149d2fdb487e0b898cfd7c776278be4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8161c17739677bec072016e5dab59f181ebcefe88dfcfe0b906227267a659bb" => :catalina
    sha256 "20f5969d0de884667ae2490253fbd22411db314497492828e1d4326f6397a95f" => :mojave
    sha256 "a0e1445076d544c498d76d04be9e6acd2110066173305d1273c47ab62b10abf9" => :high_sierra
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp

    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{commit}
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
