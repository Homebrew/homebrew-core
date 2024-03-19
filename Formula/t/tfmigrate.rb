class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "8139a470ad941bdeb5e4c7b3f6edc7677bb9190d499bbe488c22ac063ee84f0a"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acfa97d709c6b9535b85c313c88e7644f741edeab4768b18828865204f7e299d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da8c418253e797795549508dd30f1f48943697cf21056b5545eb1b2acd18ce7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa1f846d0299c966f90de336a701fce24b2f8758f6e9badcb09f7f6207376579"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ab183c7cb130f4420d94a05d5751160dc9b60818187e258f60a97d7bc5eca38"
    sha256 cellar: :any_skip_relocation, ventura:        "47fb31dfd752131756be9bee2a160e5adb39787649df214f18a61b4111f32a3f"
    sha256 cellar: :any_skip_relocation, monterey:       "6d75ecf43dae8b166bb04b62511d7c376750ccc5649bf508a6564befa4f692d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d69dc50e7af7e868088ca15d21811c20057339499f403c49452146828f8556c7"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["TFMIGRATE_EXEC_PATH"] = "tofu"

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
