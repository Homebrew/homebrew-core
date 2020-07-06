class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.17.0.tar.gz"
  sha256 "da288a8077a059fca95614e60bada65595edbde138dfa9ca2ff8974eb34acbb6"
  license "MPL-2.0"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8418093a3b01343484b145321c0f88dcea704b4755433a16918b30c37036080" => :catalina
    sha256 "81e76a5716c6a32316c45496cad502e20bdc7adc77fe7b175057ad0a3b87f2c5" => :mojave
    sha256 "71703bb43d3a7b2f3e798a07a8494e30cc06b3cb533b41e01c8c6b36781338b2" => :high_sierra
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
