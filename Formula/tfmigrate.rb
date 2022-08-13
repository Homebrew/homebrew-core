class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.6.tar.gz"
  sha256 "41521b0bb2bc63b15227a12e16c536c6c02b0cbe5b5c3750e78ff631465b4e2a"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66ac589a5a573ce07ab210046d499efe70cb8a1a74ac56eabc959f9a26a91801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66ac589a5a573ce07ab210046d499efe70cb8a1a74ac56eabc959f9a26a91801"
    sha256 cellar: :any_skip_relocation, monterey:       "4a4dab7e6b3ffdf3a48250c0d549d6b7258c51253dbfc4735bfe38df4920ed2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a4dab7e6b3ffdf3a48250c0d549d6b7258c51253dbfc4735bfe38df4920ed2f"
    sha256 cellar: :any_skip_relocation, catalina:       "4a4dab7e6b3ffdf3a48250c0d549d6b7258c51253dbfc4735bfe38df4920ed2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45eb9f6b40d98e25bfb09788963ff402a2e79b23f532f106fd7cb8ca0c686c64"
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
