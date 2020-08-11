class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.8.0.tar.gz"
  sha256 "915a3ac5faf40aea3e5f17c20b7287b7f4108e22157961cf0ca3133fd1dbef9a"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9657d870ad1cf368da003095c071a2d665d71a5822889072a3ae1be4a7eeb280" => :catalina
    sha256 "204fd8fcfc45e69ffabfe8542d75d3236654dc074f2d54ba2c5133adafdf097f" => :mojave
    sha256 "ea8479ac5feb98c108a42391f16347346e6a21226932a35f14857745d492fb97" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build.go", "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  plist_options manual: "syncthing"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/syncthing</string>
            <string>-no-browser</string>
            <string>-no-restart</string>
          </array>
          <key>KeepAlive</key>
          <dict>
            <key>Crashed</key>
            <true/>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>ProcessType</key>
          <string>Background</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/syncthing.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/syncthing.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"syncthing", "-generate", "./"
  end
end
