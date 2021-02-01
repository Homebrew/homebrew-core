class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.24.1.tar.gz"
  sha256 "aaabeca85020c518189509b1628b83cf52f2749579f308ff4bcdff8a10bb3b99"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "6dad78fb2c9a25e51c8f629840a9945a6de4489910d3b1059d818b8a1f34cb24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d645c8b0dbebb779c954f0c1563e70600cbc5ee0f5a4a78fb9fa5ba1e334cc2c"
    sha256 cellar: :any_skip_relocation, catalina: "c8056115315a70a20120e15beee28a0d7811812a32dc95c44a771b3848bd341b"
    sha256 cellar: :any_skip_relocation, mojave: "2eb177d6c33f27cbc69aa7d9fa9baeef260a6239da866dda9d7ef7784920fbb5"
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
