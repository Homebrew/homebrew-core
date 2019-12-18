class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.13.3",
    :revision => "b0f55fb766a1e512f7e7158fb1278dd00939c183"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b88b3b1d0979ee07ef901e2e5e18425401ea470137c56e1f8bcd6b898380e72" => :catalina
    sha256 "9e1ab7e60f11cbab1e732da1d9084f4a6c2e9875b7d0530a4b785fe65a3693c0" => :mojave
    sha256 "b3d56a890b32055d6fcd26a01f0ba2004b33f39c19386165530ea26fbc8925d6" => :high_sierra
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
