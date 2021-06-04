class ServerGo < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.1.72",
      revision: "5e5744bca3833072551cbf3233fbfdf85aa29902"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "602538b6b3e893a1d9176ebc7a555c9dc92706a05efdbb1175aafae3f673bc75"
    sha256 cellar: :any_skip_relocation, catalina: "741c6e3b54c1cba333b5b47cc11de242777b3cf98caf217a8416deb6009207da"
    sha256 cellar: :any_skip_relocation, mojave:   "0200890e437d3b0e8f708764e4c088206909fff421ef8a443aa15c52f3e8e96b"
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
