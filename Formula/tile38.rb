class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
    :tag      => "1.19.5",
    :revision => "0490734b74cdf96f52c9f9af4d6774a9ae0f627d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4eb930318448d4302ca69361d98b3913891cf8fc76977ff6bdb67dc6780c3251" => :catalina
    sha256 "00d5789489dbe6c29f79ae91c7a51c51d8467c968d7db25eaf6056fbb30f3aa1" => :mojave
    sha256 "ac4e401bad311a885609a71e59fa2965c9bc97d4e4735cec82277da8c0a940f1" => :high_sierra
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    commit = Utils.popen_read("git rev-parse --short HEAD").chomp

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

  plist_options :manual => "tile38-server -d #{HOMEBREW_PREFIX}/var/tile38/data"

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
