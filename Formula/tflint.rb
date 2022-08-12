class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.39.3.tar.gz"
  sha256 "d928f7f70741a6c33c2bc9b6db820e53f6f314dfa87d1591709ec395481cbb3d"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ef185724b04984e1539e0d60cd4b8d6a0a4257183b40571142041b72caaf403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e25cae7e32354a15bc55c475541b678661da2ea25691ba382a333b30c464cb"
    sha256 cellar: :any_skip_relocation, monterey:       "422243e1256ad6f7e0ea435c9e83f6ea42e94dd42e4e6320b8a78cd71b9a1657"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b23904c051a75608e94ee2c20bb645188418e33b9eedd7f0ac35e7256b591b0"
    sha256 cellar: :any_skip_relocation, catalina:       "28aee027b0eb32a724dac335577ddd4870a52f7dd4a344a428c5082579a1d6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f91ef61725e2985811a77a700db6afba11c7f10e3700aec33277fbcb9f6d28c"
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
