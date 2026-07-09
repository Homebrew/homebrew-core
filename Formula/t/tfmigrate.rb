class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "306c8d14bfbe86a532c85fffca2c4ea2cca6412bcbc4016680f81643d0d630e9"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "527a0a2f6adf35b6c7af46b767adb0606bd8fcf22c2e3bdeab9eb9974e87bcea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "527a0a2f6adf35b6c7af46b767adb0606bd8fcf22c2e3bdeab9eb9974e87bcea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "527a0a2f6adf35b6c7af46b767adb0606bd8fcf22c2e3bdeab9eb9974e87bcea"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c9c2184db05b3284d109c0012e0147bae72b55e13bec559331fc229a29e0c56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "430636bf6fc4ec275637decd04b44abee2df45d46f978ceb9456e6e5e8ed3f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11ece0b32824bd5a6b518816eed3b236921014d8a3e535aea7b9998289abf057"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["TFMIGRATE_EXEC_PATH"] = "tofu"

    (testpath/"tfmigrate.hcl").write <<~HCL
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    HCL
    output = shell_output("#{bin}/tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found", output

    assert_match version.to_s, shell_output("#{bin}/tfmigrate --version")
  end
end
