class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
    :tag      => "1.19.3",
    :revision => "d48dd2278afb4271019f53c02c9642debd1ff609"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb5fcce1ba45ed23fef0fa43cea04fcc0893902aa64487700340ff2ef5c94a37" => :catalina
    sha256 "87c83f5ad06636c2eb8f94a3feee0129a4afa005279e77bcc4a24c4e9102c65c" => :mojave
    sha256 "329a08d9ce8e0ee2944b7d26ccb78ee2579ab8d11b1fb1782b866392e20bab9c" => :high_sierra
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

  def caveats; <<~EOS
    To connect: tile38-cli
  EOS
  end

  plist_options :manual => "tile38-server -d #{HOMEBREW_PREFIX}/var/tile38/data"

  def plist; <<~EOS
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
