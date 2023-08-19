class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.14.tar.gz"
  sha256 "504dcd7bd0b5e20be25f6f95ce86195af0e79ff0dc3568a9e7ec73f60f83b947"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec4dc6a2626bf200edbee78b02c276dee4ecdaf63f79b52ac15a739f87b294b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec4dc6a2626bf200edbee78b02c276dee4ecdaf63f79b52ac15a739f87b294b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec4dc6a2626bf200edbee78b02c276dee4ecdaf63f79b52ac15a739f87b294b9"
    sha256 cellar: :any_skip_relocation, ventura:        "d6730871168fc6456652e8d2df1e4445e9e87c6bb3a65bf88dc24986f9bfb7e2"
    sha256 cellar: :any_skip_relocation, monterey:       "d6730871168fc6456652e8d2df1e4445e9e87c6bb3a65bf88dc24986f9bfb7e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6730871168fc6456652e8d2df1e4445e9e87c6bb3a65bf88dc24986f9bfb7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ccc4852e77c4b64807d06a8456dfab383889d252cbd8c45117d4313183074e2"
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
