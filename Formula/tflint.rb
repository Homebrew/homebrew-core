class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.28.1.tar.gz"
  sha256 "83df9ebc95b7a1b126d2fdc79e83c3e1d749a94f16c7fc500270f97c59c69c9d"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b445c37a0e0c29b8b833e7e99ef0399210d0e7bba1cb981d440f6c0360f4f97"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f2927d43a30ea2f29be82a89385d343b2b79e0cb553125e8b2b17362d82423c"
    sha256 cellar: :any_skip_relocation, catalina:      "8d0df88c776c44bcc34de56d0c85600c2a663d8f485aafc40e008eb4e4daefd1"
    sha256 cellar: :any_skip_relocation, mojave:        "8eee98091cc409c8179d44dddd500f025058789ddb78b8f2bd0f156f783e9ea7"
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
