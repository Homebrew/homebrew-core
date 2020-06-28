class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.8.0.tar.gz"
  sha256 "48de52aaafa5790e36d6522086c49c73bac3aff9a814164aa1b0c5f6487f1669"

  bottle do
    cellar :any_skip_relocation
    sha256 "03f966e98db8f8a8e9e5ec2b9543b89304f1254905bcfff3cfb813d2e163f9e5" => :catalina
    sha256 "88f6080a2d05a7445479b171a65e971755b621eb7d315c598c52eba9ce08f8b5" => :mojave
    sha256 "d00ceb90ed87b57e15c8b4bed8c8d2dcbb2e2e987be68f06abc2e8bee7702536" => :high_sierra
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
