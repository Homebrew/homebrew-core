class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "85d8fa6881efdd444a3102dfbddc0559380643d2d72d871c1cbe3cfd3df1902d"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "603e3f3a30094b8b86c98fcb425b286607956fe6b5f040f1cf1158bd18cddb1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "603e3f3a30094b8b86c98fcb425b286607956fe6b5f040f1cf1158bd18cddb1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603e3f3a30094b8b86c98fcb425b286607956fe6b5f040f1cf1158bd18cddb1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "993820c499d14f9eeab7d504c9d966b2bf45e1f70142cb8c4db1641785b401fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a3f8800cded05ff20287578059f556f3993e2566ae83b7710decdf0ab9e1e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ae0031a822efc9bee92b239c6f0df4a352931aa7f41ac7fc4980138ba04f673"
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
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output("#{bin}/tfmigrate --version")
  end
end
