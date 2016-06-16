class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.8.2.tar.gz"
  sha256 "2bf26bd37a4d496a6118140556ecd60ce20bc9f63cb7f6086af8d76c3e0e7448"
  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fba4a13fb55746bdea04bdaba6717f0ee1fab176b2b204f7c0915a75e2b7fa91" => :el_capitan
    sha256 "c5a952d1acc74b2c524b8103af08d61aad069755fc5237db9c9c1b75136c993f" => :yosemite
    sha256 "e4428f603ac6a74ab8a1ab250de04bbc167cc838c61164f4354e4434f22e1790" => :mavericks
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
