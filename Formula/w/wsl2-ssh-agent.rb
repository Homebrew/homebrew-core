class Wsl2SshAgent < Formula
  desc "Bridge from WSL2 ssh client to Windows ssh-agent.exe service"
  homepage "https://github.com/mame/wsl2-ssh-agent"
  url "https://github.com/mame/wsl2-ssh-agent/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "f8aa881bd477e9f12ed487dc325a79b50732b835c7d421fff80177f6ff9ade48"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    run_output = shell_output("#{bin}/wsl2-ssh-agent -socket /var/tmp/.wsl2-ssh-agent.sock 2>&1")
    assert_match "set -x SSH_AUTH_SOCK /var/tmp/.wsl2-ssh-agent.sock\n", run_output

    version_output = shell_output("#{bin}/wsl2-ssh-agent -version 2>&1")
    assert_match "wsl2-ssh-agent (development version)", version_output
  end
end
