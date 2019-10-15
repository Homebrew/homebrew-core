class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38/archive/1.18.0.tar.gz"
  sha256 "75b085b1b45ae288b4b42687925cad1dda1276a7c6d08807d12b8f78374be6a5"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "324f65bcc9118b37154d83eab2cf351e776371624cd1004de9b49a2c2c367e9e" => :catalina
    sha256 "f5d76e7f7a0874464151ac6792a0d404a2b8396bcb7a36d6f8407b8a34e78a9b" => :mojave
    sha256 "1abd14bd1217f0a522699d29af63c69cd191a75f34bdb8c91dcb1a8a2c46d8c3" => :high_sierra
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
