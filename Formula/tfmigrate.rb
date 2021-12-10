class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.0.tar.gz"
  sha256 "9baa141c2ba36e1190bbf92a70f7a58db2f9b009db5c645a50f9e23a89d5903c"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a5952e1dc57c11b16819fcd845bbf375669f5899c3d1aed0dd9beae82758ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1a5952e1dc57c11b16819fcd845bbf375669f5899c3d1aed0dd9beae82758ae"
    sha256 cellar: :any_skip_relocation, monterey:       "32b9120fe137d97857211eea610968fec6a4c2cb1b8c411c78e29aa3c94ca2f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "32b9120fe137d97857211eea610968fec6a4c2cb1b8c411c78e29aa3c94ca2f2"
    sha256 cellar: :any_skip_relocation, catalina:       "32b9120fe137d97857211eea610968fec6a4c2cb1b8c411c78e29aa3c94ca2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e9df4706a6c371a6a0adeafff883cb52dd15c1b754186fde67b79cd1282abe8"
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
