class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.31.0.tar.gz"
  sha256 "3a8a3aeae3d4b09df3c5c9eed07c2da1680191e6493c31642e0fa3f518c341da"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ec327d9213b538cb3dd338e1131ff2d4e6b12816289ccf88a82c3515fb041cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "0029f11368d1908036175629d54245816e7d3b2aca2b5797385a4e4b139c16cb"
    sha256 cellar: :any_skip_relocation, catalina:      "46b711343a6c4d84d16681d918795993f82b469f1360f50473164bf4d4797d7b"
    sha256 cellar: :any_skip_relocation, mojave:        "3b1815305dd1f9077d120f9100471331469e27980ce32ff98f0162229fd91ba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09768ffed517264e27032efe2749e71213bfa981f46ded8d468ff793eeae4111"
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
