class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing.git",
      :tag => "v0.14.26",
      :revision => "ac46db78d748f84b9cdcd81be4f033ea43112c88"

  head "https://github.com/syncthing/syncthing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e225bab3a0d556c0ff531cf07f0899f55aade8daaaada8cacaeccd92bcbcfc50" => :sierra
    sha256 "f79f20bf2007f6159d6d1905a59067c5c7dbeb6f4b6da8005aaa82293887fae4" => :el_capitan
    sha256 "feabc798c05a9676c75331a111075538ee05b63537641e9e382875113a5446cc" => :yosemite
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
