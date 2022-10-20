class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.10.4.tar.gz"
  sha256 "2960a1cdf4c60d80203b8c339d59c5029537f3bf06b373d477edd7f2288fce42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d61b098ab7972d614fbae87409908220139f4171e15e4a7d6ea0ff47f9dc4df3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa4da9f77f878d422890871b9a626dfd3b999423a2bc943e9327d92e8d8490da"
    sha256 cellar: :any_skip_relocation, monterey:       "28f9710b4b25c5168f96bffda33362107ef0999493d18c7e8fec8c1f5ae0ac2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd038ca4d854e0ea40bf6c43ee347b83929f601efe7a796710b8b1b9c2862fb1"
    sha256 cellar: :any_skip_relocation, catalina:       "445e713d2b6d0e82758edd961baea2be050ec839fc4978b2b2ed3f24fdef4fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a93054855ad39a22e10eae2c7a8cf2ec3f7283cd0cd441dfc8cc7b761bea88a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"vt", ldflags: "-X cmd.Version=#{version}"), "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
