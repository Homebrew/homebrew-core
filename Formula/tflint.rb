class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.15.3",
    :revision => "b4e81dd5bc2cd14e0aaee3db4b88999d6d111683"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "066c49fbb28286a56e5885123b1a2d8e097fdf0cf391af6323f29d958e80f6d2" => :catalina
    sha256 "32496bbcdc496b29567a4d323a9dac7d6e81bad4c60df5d0ce597133ab4c3274" => :mojave
    sha256 "5efa186459f81013173f3cf5bd21ae1a3982efa8a502b6b459c4e97e46f565bf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tflint"
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
