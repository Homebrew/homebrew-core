class ServerGo < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.1.60",
      revision: "37a40ab1f0ec73b2653db0b22d4e5434c3ef4dfc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0e168e5705de596db16a8b7e5bfbb07fc8d25d52ce7536badfa2ca06963e27fd" => :big_sur
    sha256 "a8f9eb48ac79a628aa71ca08caeb8577a85e47b81e81968475aa5b318c536b42" => :catalina
    sha256 "58996b6453268397e81337f7feb94b346297ba14cf1db24c23b0f05d0c19e420" => :mojave
    sha256 "8e49eb94a30c9f97b53a6201a165e7f07e1904f4ad9e933c4bc9e613e7c6ff75" => :high_sierra
  end

  depends_on "go" => :build

  def install
    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  plist_options manual: "server-go -c #{HOMEBREW_PREFIX}/etc/server-go/server-go.yaml"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/server-go</string>
            <string>-c</string>
            <string>#{etc}/server-go/server-go.yaml</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/server-go.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/server-go.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/server-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/server-go init --config=server.yml 2>&1")
    assert_predicate testpath/"server.yml", :exist?
  end
end
