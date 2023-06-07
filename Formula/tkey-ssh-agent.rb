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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ca5eea17cc5b9ce656512723fd0f3264618f2691c6c9f99a203e53c6d906fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67a96eb8492872553954d9febb60f4288f098823089dad937eaf686ba8cf3431"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88c4dff50fdc0d489dd4945877cb044b341040252cf79e43b1a6e42054930371"
    sha256 cellar: :any_skip_relocation, ventura:        "ac79fd3952281c2aff071a0f0682c89cac75ea59f46909638036a3b869155e57"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc85f026d6e6cd72cb0983061438de571f5fc39bf070e8a332655f08faff2d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b6521eaebf5a417c218b1fe90b89b4d66330ebde5d19e50266c13c7758f9d3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0105a5d58f65721883759cbd6e75791d507c122f77a68ea878d6425a5644268a"
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
    run [opt_bin/"tkey-ssh-agent", "--agent-socket", var/"run/tkey-ssh-agent.sock"]
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
