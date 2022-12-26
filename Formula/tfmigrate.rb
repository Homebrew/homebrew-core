class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.10.tar.gz"
  sha256 "8595bbce061943b6c16d63c4410944e99158e3dc460f88194a3c8f1b91222da9"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c40cac30e79c34f1d9aa7db7603b5597e502825d48e1656949bb496bc735ee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c40cac30e79c34f1d9aa7db7603b5597e502825d48e1656949bb496bc735ee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c40cac30e79c34f1d9aa7db7603b5597e502825d48e1656949bb496bc735ee1"
    sha256 cellar: :any_skip_relocation, ventura:        "0d7824057d674caf906f525f8c28f242c0afa9586d9e3c93d85ce01c7b493857"
    sha256 cellar: :any_skip_relocation, monterey:       "0d7824057d674caf906f525f8c28f242c0afa9586d9e3c93d85ce01c7b493857"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d7824057d674caf906f525f8c28f242c0afa9586d9e3c93d85ce01c7b493857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18a9da7b952646cfe1a715a49745fd21c5476b7082620c666bba479df18e2402"
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
