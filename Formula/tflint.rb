class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.13.4",
    :revision => "5a562ba4f82dc2bda691b0a39f8f8d04c18f6f05"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c376b79e46214519b33a540f191fca4301b8a4bbb6762f334414529c54ccf051" => :catalina
    sha256 "895c6119330b168d74e2aa0773fba528182e9a1b052dfa40ccfd4a600b62f6e4" => :mojave
    sha256 "6540cdaa0b282abb6b4e209e835dbf44d219cc0fd54966e5594d0e90f2933b40" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = "${var.aws_region}"
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
