class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "6ca61f363e8eb07f6d68df961e16647c7d98105aee2f7cbfdc1a9b741cb2e9e6"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e77933fa8645a86fb763d17bf0c4bc68f6cd28c3a692f917340b441c74700a7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e77933fa8645a86fb763d17bf0c4bc68f6cd28c3a692f917340b441c74700a7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e77933fa8645a86fb763d17bf0c4bc68f6cd28c3a692f917340b441c74700a7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d9f17aa8f8f08178380b04dca0ea7810f84bf2cbb9e0058cffc9cadaebd1e49"
    sha256 cellar: :any_skip_relocation, ventura:       "0d9f17aa8f8f08178380b04dca0ea7810f84bf2cbb9e0058cffc9cadaebd1e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f7173102b3ee87af7ae48301b773e9cd909b90bfe4184c8073082ec91f0f83"
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
    output = shell_output(bin/"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin/"tfmigrate --version")
  end
end
