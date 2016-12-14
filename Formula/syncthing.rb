class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing.git",
      :tag => "v0.14.14",
      :revision => "1ef75be1c6e97fc3133c6a27003eecdda9804472"

  head "https://github.com/syncthing/syncthing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ab714f22ab6935fac70f72ddba83e44d60e4639c64e7dc5561f4895691f242c" => :sierra
    sha256 "93deab153d656e956a99325d75c1274a9bc3217f5f55dbd678e2bc44dda89960" => :el_capitan
    sha256 "8f5708e04fd283c535a7bc3159f47d0ee2ab0b07d875314ae348121d752af775" => :yosemite
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
