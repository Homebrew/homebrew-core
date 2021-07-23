class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.25.1",
      revision: "6e52e3a7eb49266b5c91d31debf44d2038892ebf"
  license "MIT"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56b7a1a92358f582383655f0677ace0916fc9cee202e8c365444fc918f5f89c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "5543bb2cb6d2f53f4472aa0fac65c885a3a1169d431c2d00ebe6b6c020e8307e"
    sha256 cellar: :any_skip_relocation, catalina:      "6e1ea4135dd7441ce7807013535fa60ebc779566998f3f0081cee1f7ed159618"
    sha256 cellar: :any_skip_relocation, mojave:        "f84929bab43edfdcea870378bb04ddda9b77f6e3dbc10a17df3c3003cecce1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40a297e53a7552c62b85573c5f684e7b9a3db7609d039b1e0f0237428ce46d32"
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
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-server", "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-cli", "./cmd/tile38-cli"
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
    port = free_port
    pid = fork do
      exec "#{bin}/tile38-server", "-q", "-p", port.to_s
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli -p #{port} server")
    tile38_server = JSON.parse(json_output)

    assert_equal tile38_server["ok"], true
    assert_predicate testpath/"data", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
