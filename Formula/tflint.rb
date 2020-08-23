class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.19.1.tar.gz"
  sha256 "e4e0749a98149c5dd7ea24ff433f951c0d44a962883133a39aaffc4c5af1898d"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "613ff1432d85c3894f41d92ac006f350b85413d88b870ba60f50719773977845" => :catalina
    sha256 "abcdd6c66a025cf9f88e88287eb2ea0899d8fb7089ed771df29785233a366e3e" => :mojave
    sha256 "a7de841e9b30a3e214eb8d95e3aea43f53b33d75e69398cec40201fca7059bc1" => :high_sierra
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
