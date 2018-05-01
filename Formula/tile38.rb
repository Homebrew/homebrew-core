class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.12.1.tar.gz"
  sha256 "f433ab485b058cd197b77fb7c34f23cca735b123ac956c5c15296d9d5e352a17"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe6cb6983a73d2e97210a6ba0ae1b657f0cf7bbb910c39b0f0849693a4fd79c2" => :high_sierra
    sha256 "430eb77acb61a93538b74fa931db54f3d3777cae62124e362f00af9b551f0d3b" => :sierra
    sha256 "691b0ea2317389ec54391019865029e97f08d48d81dc809f45cf09d718d379bc" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

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
    system bin/"tile38-cli", "-h"
  end
end
