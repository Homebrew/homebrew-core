class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.12.0.tar.gz"
  sha256 "ca054d40109ff970fccd29efc425fc249b1824bf9dccfdc50e461d9e980ba014"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f599ed5e984d370a1a57476cafcc53a5fd46eca4ed91e953632d4ab64e4dcb1a" => :high_sierra
    sha256 "4781e8b1782f0dfd1b30834db0c4e0072998a129edcc9e9d6db62592f7fe1458" => :sierra
    sha256 "f20e835db4787e1504a4457078cb22e1c0b337a9a85281b5bc12aced1edbe590" => :el_capitan
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

  def caveats; <<~EOS
    To connect: tile38-cli
    EOS
  end

  test do
    system bin/"tile38-cli", "-h"
  end
end
