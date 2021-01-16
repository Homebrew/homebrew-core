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
    sha256 "0a4a8dfb56f8d155af2f145244ea98c5dc1dbc22cd34794731920ab988d9feba" => :big_sur
    sha256 "27bf41849f2ca5517944c9255f478d2c2bc3e114b391563683ace75b5bd68be1" => :catalina
    sha256 "b7bc5e04789a9402b32ede05549a25b8b0b269fcd690b00960692cfc5e001412" => :mojave
  end

  depends_on "go" => :build

  def install
    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", "-ldflags",
      "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew", *std_go_args
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
