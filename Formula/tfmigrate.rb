class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.2.tar.gz"
  sha256 "a441f57cd64c32fb3c42f1c8c37ccffeed38aacd119b6c7415e8e073c194f947"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11057a93fdb3e318fd81b72767eba0842368b94da5bb709aee2e68b0ca8ca183"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11057a93fdb3e318fd81b72767eba0842368b94da5bb709aee2e68b0ca8ca183"
    sha256 cellar: :any_skip_relocation, monterey:       "c45a36fb0a18b60bc5c3121d7d4c97f6385f296c5594a0d88623aaf56bad08e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c45a36fb0a18b60bc5c3121d7d4c97f6385f296c5594a0d88623aaf56bad08e0"
    sha256 cellar: :any_skip_relocation, catalina:       "c45a36fb0a18b60bc5c3121d7d4c97f6385f296c5594a0d88623aaf56bad08e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8dbfe5514e2b1fef135389fcc1f36ef199611ebbfa72c35a0c5565ad413bb8b"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"tfmigrate.hcl").write <<~EOS
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    EOS
    output = shell_output(bin/"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin/"tfmigrate --version")
  end
end
