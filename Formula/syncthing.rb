class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing.git",
      :tag => "v0.14.37",
      :revision => "c7221b035d94d459fe8bbe1e88df67b7d320b216"
  head "https://github.com/syncthing/syncthing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "260169c65106d40f71b2d2cdd68e9e387225933e116ea8e6c65e90f01db01406" => :high_sierra
    sha256 "51c477f71ef60a3d84338feaa719caca343bcdaff1ebfbb682ba6b96ad816b29" => :sierra
    sha256 "dae4d476b58cdc6b73a60a1eb052247af02cc210959152cd2a49fb1dbda5f154" => :el_capitan
    sha256 "ae49ee1d234bff0b33e7cd05b53a645c4e5dc7cdf1e781ffa105a51d1acbcf20" => :yosemite
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
