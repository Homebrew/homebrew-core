class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.15.3.tar.gz"
  sha256 "878498373f45e6a34a3e1016339309ba973d7f13887430ec9674d745a751e170"
  revision 1
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ee21a8ae9f49a8fccf92cc3d7f78e241529643263f4c5350b09915190b0e7ec" => :catalina
    sha256 "15cdb64b66fe827c42a5a1ad8eb7329d0cdf0189c1be3bae8b21e5e7aae077a5" => :mojave
    sha256 "02fae1a81d35a7973500ba24b835fa40aa9d5de191b497d513338789a8901c50" => :high_sierra
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
