class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.8.4.tar.gz"
  sha256 "c8215c8bc8a52a043ae3bcba6ff94ef572159ca5d7808b44deeb31eb3b2ce295"
  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    sha256 "9abaaa025ea4448c7f0a98a2fe4dd083640cf808a98192b878bdbd32e927dd43" => :sierra
    sha256 "dca3eabfc41811d174fedf04301c3279418342fc9cbc39d1b33765e7e185df8a" => :el_capitan
    sha256 "b53bf4dc4265aebdb7d536562224a34ed1dfa1637a110208c344e80b0587028d" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
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
