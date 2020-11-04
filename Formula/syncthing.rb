class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.11.1.tar.gz"
  sha256 "741d339dad6335f9a2fb9259a1b57c82896d9363d92a5c9ac2573068bf1859b7"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "586b4b37d9300aa93ff433c4ebcd18d29863cf466962802fdf2ec31b9a72f76c" => :catalina
    sha256 "5ea876c0c49923cc75b31ff0a4598cb0876597d5ca8335bb8d0bdb562d7168a3" => :mojave
    sha256 "5433ef70f0ac9709aeeffc88a7ab1730113c0ae4fed5fdaf17121b7ab24e1b9e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build.go", "--version", "v#{version}", "--no-upgrade", "tar"
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
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end
