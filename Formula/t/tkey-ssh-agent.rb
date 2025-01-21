class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tkey-ssh-agent/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "abe43e1948101a5da007ff997161216ee7d44a54e3fa6b0aa255c22fcab11ae1"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "92e34132b71fc3c562a8353058c5deaf720fc80f243dccd3eb5dac62a95c2d65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "858a66ab63cfde2b070de13ee0d7e440a13d3215c3fb8f97714fa28b5c20b4d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c191dcb7265469492b7bdc6f9acd2acdee23149d96c5e91d74bd7a01c90a8d02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b84ded0ad2a15580436087607efaf173b28356d4ce46ace2862947d4cb41b05"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3f4b8eeaf67e42b56043d539607a54f5a28eb6ecea69c3d62744ac027c8865d"
    sha256 cellar: :any_skip_relocation, ventura:        "80ff5be57d0784f94c05403897524d25f26779a0474eb5699833134f575fa7d2"
    sha256 cellar: :any_skip_relocation, monterey:       "464090fb25f2826ce0495ebd2d17c39276726044e3d6bc87ea22ceac9d7db469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e001c74cb92e401e908892f2baedade9fc815124f6ca28b45db0c06c3599172"
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
  end

  def post_install
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
    fork { exec bin/"tkey-ssh-agent", "--agent-socket", socket }
    sleep 1
    assert_predicate socket, :exist?
  end
end
