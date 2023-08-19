class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.14.0.tar.gz"
  sha256 "48b05532c8f3e02cf241a013a3e5a7747e9e882018e17fbf40c6a6b46af00fa8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6420aaa30b5ac53b16a08d5b3cc50dcebba41848ad1f135ae51579a03ae90fe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6420aaa30b5ac53b16a08d5b3cc50dcebba41848ad1f135ae51579a03ae90fe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6420aaa30b5ac53b16a08d5b3cc50dcebba41848ad1f135ae51579a03ae90fe6"
    sha256 cellar: :any_skip_relocation, ventura:        "7cbc374310357980da7ed1e86f59da70cbc3f6897907aa4fb0a75f13f0575799"
    sha256 cellar: :any_skip_relocation, monterey:       "7cbc374310357980da7ed1e86f59da70cbc3f6897907aa4fb0a75f13f0575799"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cbc374310357980da7ed1e86f59da70cbc3f6897907aa4fb0a75f13f0575799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "307bff82f7318cd44c26378d911c71c6afd811dde1b56df51e53792aa0443e61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"vt", ldflags: "-X cmd.Version=#{version}"), "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt")
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
