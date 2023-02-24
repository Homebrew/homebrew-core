class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.11.1.tar.gz"
  sha256 "76e546a612a1eee0d0522be8dd8cd9d9c4ae42645417335bd05038d835befbd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e39d385e108e5bd35c3840822cdf147a4efa12627ff9864c97a136ec9f40dae7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac0a0e5b0f363dafbc330605067fbff45256e9189821dd2a518f92f412a03141"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f5a48643f8fb5832614662e83e9830698821642ac632dd3678506725b92d76d"
    sha256 cellar: :any_skip_relocation, ventura:        "45ca62bde365b041ae6da8d5d1ecc7c1116e3ebba546713d32812ef9f044ba4c"
    sha256 cellar: :any_skip_relocation, monterey:       "1549869b8da937f0258977110c4f29a4375b50177d353e1c609c2bf80f0794c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ee8259bc0ae0c24d11e20fd9eb7bd052bd483de38226630fb3da7c2fdc91685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52fcaf3680f07a8f7f72dc3fbd7fc607ce4c56384a747cf53e6755b9b0b2bafe"
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
