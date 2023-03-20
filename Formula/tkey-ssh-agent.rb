class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tillitis-key1-apps/archive/v0.0.4.tar.gz"
  sha256 "b3f3547401159a8a4277a4b9689632699cb6cf5bebde6ba6a093aab80b1e7ea9"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c99cd35b8b9151430bf011fdcf20f0ec6debd3971d2cf0f7166195d3843688bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a820a1814e836a720f87236442edf6e8683dc76fa2ad1c0e06e91a9309663094"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35abf52ced85ea3539f362daa8c23b98debfb028d4b291db05ca382d03cdd94d"
    sha256 cellar: :any_skip_relocation, ventura:        "d0505ece81479ebf6832f8987fb72f6dd62e8de872189db0b9f3540a63563f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "9b291196d56d9a84a847f4337fbad530a4b88cce303ece39716e10855d7ea7bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e10dcf27d94c7ec2392812743d69648e810363bdf464c21a6ccac77ac25e8b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aea8b0212bc5cd1260d5419cbe8dde5c9425b841344079885d99abd05b4de23a"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "pinentry-mac"
  end

  on_linux do
    depends_on "pinentry"
  end

  resource "signerapp" do
    url "https://github.com/tillitis/tillitis-key1-apps/releases/download/v0.0.4/signer.bin"
    sha256 "efec2aa4a703964f19e4079707c5f3f3f3ba3fe06b44833173581b42b0abd258"
  end

  def install
    resource("signerapp").stage("./cmd/tkey-ssh-agent/app.bin")
    ldflags = "-s -w -X main.Version=v#{version}"
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
    socket = testpath/"tkey-ssh-agent.sock"
    fork { exec bin/"tkey-ssh-agent", "--agent-socket", socket }
    sleep 1
    assert_predicate socket, :exist?
  end
end
