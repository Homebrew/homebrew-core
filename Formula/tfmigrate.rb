class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.5.tar.gz"
  sha256 "6d0970f87b191312d4494ba35dfce3fdc2f4247a0061199ea81560aef917448b"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a79b151be608995e3af3cc8a5e5218e875da22a9a1ee944fdefa4b7875659b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47a79b151be608995e3af3cc8a5e5218e875da22a9a1ee944fdefa4b7875659b"
    sha256 cellar: :any_skip_relocation, monterey:       "fd0fd22db21dd194e03e0704ad853be66d9413fe7385171f59a020b4606a742d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd0fd22db21dd194e03e0704ad853be66d9413fe7385171f59a020b4606a742d"
    sha256 cellar: :any_skip_relocation, catalina:       "fd0fd22db21dd194e03e0704ad853be66d9413fe7385171f59a020b4606a742d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fc846bed4a221648cc530bfaf1902b69ad7f9f95d0e99bc6f68a0bbb31ea735"
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
