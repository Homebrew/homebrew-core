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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12f0f2068128036add825cab6c379ff57b17288e675ef771e44931fa8fb1aba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83e57ea747aea61d45c1099babd1eab023581b3e43f56d3df3409bf02cd6a947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3323c0dc0b5ea7e421a341443472bfbbfdc6934625c8d957dc1b80677df4fa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "207012f364b1ee24f1a1da21b05949e528ed3c09ef611fe593089ff3166ca2f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "843332db81352ee2130ed860b1ee03a30da62e881abc6d1a5b435ab0e2f5e68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dcd2f951740ed9dd9814e7009e66dbc3f7409cd8095083ca5f2e813e8d7723b"
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
    (var/"log").mkpath
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
