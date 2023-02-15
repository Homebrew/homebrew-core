class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tillitis-key1-apps/archive/v0.0.4.tar.gz"
  sha256 "b3f3547401159a8a4277a4b9689632699cb6cf5bebde6ba6a093aab80b1e7ea9"
  license "GPL-2.0-only"

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
