class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tillitis-key1-apps/archive/v0.0.6.tar.gz"
  sha256 "d15fc7f556548951989abf6973374f71e039028202e8cad4b70f79539da00aff"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b00f8db7fb3ec5aea7d08770da1a30de735ea365845c0dba0bd70c039116d82a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ee703b7d46264fb1adce0b6187d19719cd2210be3fd183bc1fa34ce0b33ed8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdba6e501630f4265b5905162e3c7adc3ce7360451422660b6ddf3872630b901"
    sha256 cellar: :any_skip_relocation, ventura:        "155165d00aac01bbad4dae356ad2c240ad33d53458da154e8f8173d5ebbbcfce"
    sha256 cellar: :any_skip_relocation, monterey:       "95d87b785d72bfe0ef2bf50601c2f780c6096119734b6d81962c3f035066f0ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "4947e759c1abfe46536aadfe8f2ab7b1651a3568b6b49a1cecced1d81b576238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea710fcd774b3c3f75da1f62462b0137952f8f6b4f9fc50350a45a5830fb18e"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "pinentry-mac"
  end

  on_linux do
    depends_on "pinentry"
  end

  resource "signerapp" do
    url "https://github.com/tillitis/tillitis-key1-apps/releases/download/v0.0.6/signer.bin"
    sha256 "639bdba7e61c3e1d551e9c462c7447e4908cf0153edaebc2e6843c9f78e477a6"
  end

  def install
    resource("signerapp").stage("./cmd/tkey-ssh-agent/app.bin")
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tkey-ssh-agent"
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
