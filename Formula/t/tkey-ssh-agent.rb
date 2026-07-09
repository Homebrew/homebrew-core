class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tkey-ssh-agent/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "cdd91008020d1c68778c8bc9869e77f230a314cb389621e3fa0aa1034283faea"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edb893d7da405b29310a28fa7cbb7116243741146d95045e84adfc84fd8aefd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d208c163295411b0f2960d7874601f9ebcb20981a46ce13af48c7562aeb90225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "080190575410f16394819365b25c8771fce80fe6903ac8385b0a9cc56d5f668a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af3495f4d19250e7e8d148d644c69424a46b54b8c0e79c1d438f92827699743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d884e14bcc18eb6f6c43d09c7bb9717ed09e43bc0af7e628453c835de8500ff"
    sha256 cellar: :any,                 x86_64_linux:  "666f849c40edfdad37adb16b00e1e3de3d9af5f23a301c17a8d9d152fa411942"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "pinentry-mac"
  end

  on_linux do
    depends_on "pinentry"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tkey-ssh-agent"
    man1.install "system/tkey-ssh-agent.1"

    (var/"run").mkpath
  end

  def caveats
    <<~EOS
      To use this SSH agent, set this variable in your ~/.zshrc and/or ~/.bashrc:
        export SSH_AUTH_SOCK="#{var}/run/tkey-ssh-agent.sock"
    EOS
  end

  service do
    run macos: [
          opt_bin/"tkey-ssh-agent",
          "--agent-socket",
          var/"run/tkey-ssh-agent.sock",
          "--uss",
          "--pinentry",
          HOMEBREW_PREFIX/"bin/pinentry-mac",
        ],
        linux: [
          opt_bin/"tkey-ssh-agent",
          "--agent-socket",
          var/"run/tkey-ssh-agent.sock",
          "--uss",
        ]
    keep_alive true
    log_path var/"log/tkey-ssh-agent.log"
    error_log_path var/"log/tkey-ssh-agent.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tkey-ssh-agent --version")
    socket = testpath/"tkey-ssh-agent.sock"
    spawn bin/"tkey-ssh-agent", "--agent-socket", socket
    sleep 1
    assert_path_exists socket
  end
end
