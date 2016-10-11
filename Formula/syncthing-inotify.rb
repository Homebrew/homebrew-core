class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.8.3.tar.gz"
  sha256 "2c8ac5152056ec2f106f00f62458db478c3e8cefa11c9f6aadfeb86eccdcb811"
  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ac1dcf264f1969ca962acaf0e486b356f51a791845f56f07116cd6f880f88f0" => :el_capitan
    sha256 "dd038217ba9dbda2d7e1626e63f144ca66a36b19b6b726bc33502286b33b9755" => :yosemite
    sha256 "960a018f4daa6174e9f8205055bbe6a41addd172fb3e4e7675ad17b9eb6ea26d" => :mavericks
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
