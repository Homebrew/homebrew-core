class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.8.0.tar.gz"
  sha256 "48de52aaafa5790e36d6522086c49c73bac3aff9a814164aa1b0c5f6487f1669"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "072fd4acc2fd89c9cc86a6e6b6d00beb7516d827d71cdddb24e4cf1e5bca4af1" => :catalina
    sha256 "ae56372cafffdfd83a1ac55c917e963882139ca586c069a4d0e7c1f0e303f0fa" => :mojave
    sha256 "7fc169a764eb94967cd8e88b5420e5202415ae1715e0dde1c1a6a23951f7e23a" => :high_sierra
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
