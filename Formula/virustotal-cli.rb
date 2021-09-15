class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.9.7.tar.gz"
  sha256 "3effbc318116ddfdc41c2d8e5e885da93f43614dbf1704557bf9f347553bd5ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41f0fa1b0a8744878323478f8bb5189c70d21dddc1a7e326294e31f7c44464ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce8bd2abe3a1137debb26192a4bf43faf2064a54cbf4f7eabf94256317973baa"
    sha256 cellar: :any_skip_relocation, catalina:      "bf9f0b5b6577a82a8410774087d6ef894ba68a4e465dd8a5e0c9093c5828bab6"
    sha256 cellar: :any_skip_relocation, mojave:        "a66cbde56c35079ad8af5c80c28ae892c57f0c750fa64be992b207a645235a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfbca0fb8d2885fd92cf8c276ab80a29534c5d4a9a755943a98b6f7182e7722a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-X cmd.Version=#{version}",
            "-o", bin/"vt", "./vt/main.go"

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "bash")
    (bash_completion/"vt").write output

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "zsh")
    (zsh_completion/"_vt").write output
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
