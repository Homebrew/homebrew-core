class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tkey-ssh-agent/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "de9cec8f637378f67b48edc6f8b99301038c07c4f6ce953afa10a5bf78f4f93b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad7cb270b939ad428cc2436c0d42d2c7dc80933e1211343cebbec7eecddce9f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74bc547d565af02f5b36c04f05f438d7f94405a74f9e3124fbdee0c0a2c966a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76d18168bf63ffaff7865cd8508b6b6ec46088f900f1804b713a8a907e3cd243"
    sha256 cellar: :any_skip_relocation, sonoma:        "225a1243418f98c60177399981001ddc5d27bf8b1c90e03e8a301b24d377fc77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9ff44f25076e7a640e58d70e2766af0e48a69cc6385f12bac76071631f8267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fd9af4454ada9bd50475fcf29714cadc450c839cc7b917a191d8e0177b85e9c"
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
