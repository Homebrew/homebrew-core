class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.18.1.tar.gz"
  sha256 "808a373c3fed3eae7631bbf1edbced14abb050240b1a0ff6caff0980af7f0f01"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93408ed3d13d1a9b7d4388b7857e43e43c734c3f36d20aabf7f2fb64292116b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "97cfcafe079181f9a20e0673770d5561cd1dda8d0ee8926069000138c0f8738d"
    sha256 cellar: :any_skip_relocation, catalina:      "90fc7936bc0cff2f2f72e92ebcc20c1d26cf59fbcc619cecefb7319ed20799c1"
    sha256 cellar: :any_skip_relocation, mojave:        "134db0b81f91e980ef4308458f36bb752cf26decd5089f1a27194408ab5195d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "864f0e8513996dd076feddddf35068ea78165951aba089acc5b87dea8abc04b2"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
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
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    assert_match "syncthing #{build_version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end
