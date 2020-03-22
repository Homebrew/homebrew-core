class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.8.7.tar.gz"
  sha256 "bf7a71695206c765cf407d85656f6f0f8be1715af3d3bb7f81985f749162a6b2"
  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    sha256 "36c76a71e9270253c2182cd77058a9848bbc4cf7dcd5543ddf721104726a8192" => :mojave
    sha256 "2185ac4821dc09e211297aebb86ed7bf44e7fd6fed461d092e294c0862ed81c1" => :high_sierra
    sha256 "442dd6b530e40bd18668f482f2071afa64fcf333892ae3b8a47f435d74396baa" => :sierra
    sha256 "651c2857b6b05a2122123e520153db5605f5b89b255b6fd99e785e9465e64691" => :el_capitan
    sha256 "da3e6893fd0d8b2a17f6bb486c1e9d23d3066a36faac1e845d8d373e2a5b32b5" => :yosemite
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
      prefix.install_metafiles
    end
  end

  plist_options :manual => "syncthing-inotify"

  def plist
    <<~EOS
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
