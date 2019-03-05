class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38/archive/1.15.0.tar.gz"
  sha256 "e747995b36e49abaaa45e39fc952b164dc1255055b6fca1578738f750d98575d"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "437be73b72b8edacecf60ffab7dfcb0c18f8989794136a6fb1786e11ddeccce6" => :mojave
    sha256 "e520fc92750c39734874b6cb546044cdc6f4efb5dc4a152458292ecf43a4cd98" => :high_sierra
    sha256 "5ccf66e942d8f60eaabb1c7c379458c6555aff2df5d9a666f71636a6732a9e61" => :sierra
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
