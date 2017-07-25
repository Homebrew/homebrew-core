class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  head "https://github.com/syncthing/syncthing.git"

  stable do
    url "https://github.com/syncthing/syncthing.git",
        :tag => "v0.14.33",
        :revision => "d475ad7ce1c994358888c2fed250427ed0ef0243"

    # Upstream fix for a sandbox violation triggered by the noupgrade option
    # Reported 25 Jul 2017 https://github.com/syncthing/syncthing/issues/4272
    patch do
      url "https://github.com/syncthing/syncthing/commit/414c58174.patch?full_index=1"
      sha256 "07419dc8b75766b2e4788d8eee1c80ed4238e262d1474813a6b6586494bf1aef"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "65ac9f1335c15bb4d31cdbd21849b6d21e9046d4d0eac9aca89fa1f63feef41b" => :sierra
    sha256 "3314d62cb8e9a7d180312c9013d52160d19ce8ba7c248b8f12503bbe829d839e" => :el_capitan
    sha256 "472bd7a4d78109979326971fd8bc045765f358306c9e132acf4deb96811776cd" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/syncthing/syncthing").install buildpath.children
    ENV.append_path "PATH", buildpath/"bin"
    cd buildpath/"src/github.com/syncthing/syncthing" do
      system "./build.sh", "noupgrade"
      bin.install "syncthing"
      man1.install Dir["man/*.1"]
      man5.install Dir["man/*.5"]
      man7.install Dir["man/*.7"]
      prefix.install_metafiles
    end
  end

  plist_options :manual => "syncthing"

  def plist; <<-EOS.undent
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
