class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.8.0.tar.gz"
  sha256 "48de52aaafa5790e36d6522086c49c73bac3aff9a814164aa1b0c5f6487f1669"

  bottle do
    cellar :any_skip_relocation
    sha256 "36fcf039fa5264b8841ba3ba954816031cb1b6ac42aacd26b1e5791b643fae30" => :catalina
    sha256 "be3fd19af1b5004ccf95ef0996fa387b88e7bfa30ca651dd69b94700fb92dcec" => :mojave
    sha256 "118eaafec3d20e709091266c786d5121b27e0d1c8d8ded2f5c21c77046b571d5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-X cmd.Version=#{version}",
            "-o", bin/"vt", "./vt/main.go"

    output = Utils.safe_popen_read("#{bin}/vt completion bash")
    (bash_completion/"vt").write output

    output = Utils.safe_popen_read("#{bin}/vt completion zsh")
    (zsh_completion/"_vt").write output
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
