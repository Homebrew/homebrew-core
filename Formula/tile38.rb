class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.12.3.tar.gz"
  sha256 "cce456df7a98a8901e3c6d7d468a9b20e841475cb255493ce368b991d1ab8d95"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a26c17203bc3d40326653a0b541527ba6920863e882c91d8c3de54a70079608" => :high_sierra
    sha256 "6bde0d100a12cb3091bb878d6dc6a0408497efed05829e3ab3ad21b1da9f80a8" => :sierra
    sha256 "307e57b5862a59b0398d090cbf8215f7fce2b58c8ccaa480b2bc102ddb3068f3" => :el_capitan
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
