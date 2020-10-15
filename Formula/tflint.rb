class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.20.2.tar.gz"
  sha256 "5598d622ab19c2f6ebb4d18014dd2e9968ac7f0491ffc9e68b0baf9be1320801"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "322d6d0765d9fd26c5feb12a489a7d198a2d713f443a4682a04ab9e9d8026471" => :catalina
    sha256 "81a6c1195a4bfbe6a3774ee2580ab25125a215c4c39c607745a8252ac1d9d20e" => :mojave
    sha256 "ac913d49a04c94d05010f1663d10b8b9655398f860f399a5ebdd0502fe3a65f6" => :high_sierra
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
