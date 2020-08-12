class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.8.0.tar.gz"
  sha256 "915a3ac5faf40aea3e5f17c20b7287b7f4108e22157961cf0ca3133fd1dbef9a"
  license "MPL-2.0"
  revision 1
  head "https://github.com/syncthing/syncthing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b72c6eae782325c7a81e6cd00c1b2218316aec5ced5cf9c48ea219167e21623" => :catalina
    sha256 "8fba96548b9217f52fd422e8ea0492292ce67a77f33de1b281291093d001d47e" => :mojave
    sha256 "c283826a65b061d3636177def458b784c63457a099f511fba9de25a41eeb967e" => :high_sierra
  end

  depends_on "go@1.14" => :build

  def install
    system "go", "run", "build.go", "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  plist_options manual: "syncthing"

  def plist
    <<~EOS
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
