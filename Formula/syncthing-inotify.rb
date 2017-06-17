class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.8.7.tar.gz"
  sha256 "e5ba978039de457f35f2923d0e97b163e412c55104d275c2ba211ce99d05e633"
  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    sha256 "dec93b9b38dbb1eb1ac03ee0ba536f48b1cf87f224fd193ffe64f4f824de4646" => :sierra
    sha256 "f9fee9216c207e1c2ba0b004d4a5dc83a204a5845c7a6445999ba4baebb0d8bb" => :el_capitan
    sha256 "c6ad5afd61f7c91fb4ed60c6bfccee2a1d9ae532509a7edd2ae24bbaa74dbd4d" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/syncthing/syncthing-inotify"
    dir.install buildpath.children
    cd dir do
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
