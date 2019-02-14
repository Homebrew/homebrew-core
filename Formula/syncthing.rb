class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing.git",
      :tag      => "v1.0.1",
      :revision => "1e69997ecdbf87ceaad76bd0149d98f560f4fdb5"
  head "https://github.com/syncthing/syncthing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dae415f2ac3d7319a440c8ea261d75b7b3ed4043c2a4e86291cf45b1e125edde" => :mojave
    sha256 "e4e42282d3e0265dc0e4a7e37827b182bf5f9b255253f0f85e35916d20a4c905" => :high_sierra
    sha256 "8294b3d3c9806a69b39c17bab01dfe61d07d853e61ad8b8c7f1f623b41386722" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/syncthing/syncthing").install buildpath.children
    ENV.append_path "PATH", buildpath/"bin"
    cd "src/github.com/syncthing/syncthing" do
      system "./build.sh", "noupgrade"
      bin.install "syncthing"
      man1.install Dir["man/*.1"]
      man5.install Dir["man/*.5"]
      man7.install Dir["man/*.7"]
      prefix.install_metafiles
    end
  end

  plist_options :manual => "syncthing"

  def plist; <<~EOS
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
