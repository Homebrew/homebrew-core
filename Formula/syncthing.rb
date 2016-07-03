class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing.git",
    :tag => "v0.13.10", :revision => "223e14b0d026d3955740f0cd31aee2ce8a28daf0"

  head "https://github.com/syncthing/syncthing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cc57b32342b169e6e37c5d070a85d00a76a1d9aee05c9e32cf91088c9c4e70f" => :el_capitan
    sha256 "26ad79d7437ed14e9f999c53c9a43eee2548af7ba6c768f6cf1a2dd13caea224" => :yosemite
    sha256 "43a6129a7d63b699a628861a7ff457e17439081d1ca1cf43a879eb517e544247" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/".syncthing-gopath"
    mkdir_p buildpath/".syncthing-gopath/src/github.com/syncthing"
    cp_r cached_download, buildpath/".syncthing-gopath/src/github.com/syncthing/syncthing"
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"
    cd buildpath/".syncthing-gopath/src/github.com/syncthing/syncthing"
    system "./build.sh", "noupgrade"
    bin.install "syncthing"
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
