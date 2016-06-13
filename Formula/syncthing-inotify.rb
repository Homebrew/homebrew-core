class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.8.2.tar.gz"
  sha256 "2bf26bd37a4d496a6118140556ecd60ce20bc9f63cb7f6086af8d76c3e0e7448"
  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7537c6837dc710bfa679600875d6a8027dce8a1314e25fad19d51c16d9dc2284" => :el_capitan
    sha256 "b4251c1b4761aa939bb31067a36d971ee5861b38175195e46f4a765da3afb0f2" => :yosemite
    sha256 "02786d3f432567c9250b19967bd61efdb190d129e107f990b7db501db8de9d81" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/syncthing/syncthing-inotify"
    dir.install buildpath.children
    cd dir do
      system "godep", "restore"
      system "go", "build", "-ldflags", "-w -X main.Version=#{version}"
      bin.install name
    end
  end

  plist_options :manual => "syncthing-inotify"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/syncthing-inotify</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/syncthing-inotify.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/syncthing-inotify.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"syncthing-inotify", "-version"
  end
end
