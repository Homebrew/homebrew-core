class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.34.1.tar.gz"
  sha256 "a51334c79b722dea24ebb71b4c64ffca0c8d1bb8f77157e1675ad1d9875009d2"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33e2d2a2da58177b6758a7781dee9d9e7a84dda44b44a61c2efc6f058e6cdb93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93ce0e21ea0f8e664fe4072ad8cde0a98708b9f6d3a7d9814bac88a0f73671b0"
    sha256 cellar: :any_skip_relocation, monterey:       "dd72cbf3f7a49eda9c00169162e223c7e6818298216f8fee9d9e648100b2b028"
    sha256 cellar: :any_skip_relocation, big_sur:        "9714cbdb37bfbc8e58231c51326699e40d054d441923f1caa405a654ee06f4ef"
    sha256 cellar: :any_skip_relocation, catalina:       "b647b393f872fe8c74b1eaa437ee702f9408a12ee41910a4813e6bb45bc69731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d83238bdce38b63ec85ae97ecb82653a884435b6f1db0caf3ecdf32b365649d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
