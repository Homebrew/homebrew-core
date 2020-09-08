class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.9.0.tar.gz"
  sha256 "ca66e0929428db2ed9476ff8ef4d46b06c5221a5aa24db504cdb2cd1aebe5ac6"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0ea268a5a0ac6c9ae47192bb584f8612d27373eeadb3f9cac0308e2c94575f06" => :catalina
    sha256 "a16da5f7038aa5aea7e5ec5805eef86ac29019816f7112d38c74d58da4b57685" => :mojave
    sha256 "939315cfd61ea5ea0cad6daca2ec7d41c70632c88eb5f6d8671562f749067faa" => :high_sierra
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
