class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38/archive/1.17.4.tar.gz"
  sha256 "5ed6e9bdb93c3a20f59ce0bd9856867ea0457612329f1ae3b220d98df984f85c"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3394c764bfdca7bd4a71a62be774729974f16f124a403a4556a797bfa3c7a37" => :mojave
    sha256 "2f98b1dc7ca3e8a4273370569c666e40e1f5cccce645d6b0e2090fd5c94fc94f" => :high_sierra
    sha256 "81b1856cd61ee093714ce7dc56f864dbc7aae1df4f3a532cfe3506878e97bbd5" => :sierra
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ENV["GOPATH"] = buildpath
    system "make"

    bin.install "tile38-cli", "tile38-server"
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
    begin
      pid = fork do
        exec "#{bin}/tile38-server", "-q"
      end
      sleep 2
      json_output = shell_output("#{bin}/tile38-cli server")
      tile38_server = JSON.parse(json_output)
      assert_equal tile38_server["ok"], true
    ensure
      Process.kill("HUP", pid)
    end
  end
end
