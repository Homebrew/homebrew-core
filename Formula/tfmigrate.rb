class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.6.tar.gz"
  sha256 "41521b0bb2bc63b15227a12e16c536c6c02b0cbe5b5c3750e78ff631465b4e2a"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d6aab430a735abd7e57f3eb8121b469e9b9d3934fa410a173d0fa77704255c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d6aab430a735abd7e57f3eb8121b469e9b9d3934fa410a173d0fa77704255c5"
    sha256 cellar: :any_skip_relocation, monterey:       "067c2e2df8a9c4793b9c4cf7f5bed458548c5197a06466c20f7eb1ca31ae8a5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "067c2e2df8a9c4793b9c4cf7f5bed458548c5197a06466c20f7eb1ca31ae8a5c"
    sha256 cellar: :any_skip_relocation, catalina:       "067c2e2df8a9c4793b9c4cf7f5bed458548c5197a06466c20f7eb1ca31ae8a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caf79bc365bb78c85b6b4e16e8729d7c0e89ebaeae800a88cd0d56f3b9eea4e6"
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
