class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.32.1.tar.gz"
  sha256 "4c1004cb01f509b7c338527610dcbda2f8e888c3fe9557a4e8886e6cd1e1853f"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d86d18736d8b1408edb90903550cfce3d192e0c5f346ca3a0159ebe271262c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "76b1c0b5c8ce4527bdebc5574ab2ec79e01a2820b3ee5be012ffaf4947f11d23"
    sha256 cellar: :any_skip_relocation, catalina:      "e08e41fb179d0a3b0d55d8e97d94cddbcbb5833dd53ed91fad5c0900d7775e0c"
    sha256 cellar: :any_skip_relocation, mojave:        "a686faab129c544bdf7f1c01bc9b8324d48aeba380dad734aa72e404e531407a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45daa3e3a0d64b285486fb77599d41777c53607b4029b21704aedc077ca16a7d"
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
