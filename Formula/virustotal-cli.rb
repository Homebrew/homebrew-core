class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.10.0.tar.gz"
  sha256 "88ef4d2c7708be1bc27c2290181996b6c18e08d5f56a8765de8a5ec13f68e6ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d4f58b93a536bbcf2b658d9503589ac774ccd539e764a7f2053fb30907371ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d2077ab00005243895ddbe38b0a894451392b817700e03aa4138ffd2c516a33"
    sha256 cellar: :any_skip_relocation, monterey:       "391d9e977247084b0aaad2bbb1d2e53284122fd8a52e15705e4c0a5367371903"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ec819d3fab02f51a2f5ce9fe9b79717c28be715a781b295d11a975d7d66b06f"
    sha256 cellar: :any_skip_relocation, catalina:       "84f210895e4dbc2174089db2a8ca8a9cc210c04a8bb8d437154d79d6c59d6480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc285f90314483131000d2bbd1c07f8d82989e30515ad2dcd5cf155dc8695ecf"
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
