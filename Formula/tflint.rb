class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.46.0.tar.gz"
  sha256 "727b4652acc8ff2f0188ed25c8ea2ebd5d8879350f1415abec61bc283fb16f20"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dec64b8fe82d39dc8ba63505740acff525c1029fecf86295ab59df319862a8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dec64b8fe82d39dc8ba63505740acff525c1029fecf86295ab59df319862a8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dec64b8fe82d39dc8ba63505740acff525c1029fecf86295ab59df319862a8a"
    sha256 cellar: :any_skip_relocation, ventura:        "3697f5718a21740869ac8aebe3361693261b54fd1894578cea6cadab52e01444"
    sha256 cellar: :any_skip_relocation, monterey:       "3697f5718a21740869ac8aebe3361693261b54fd1894578cea6cadab52e01444"
    sha256 cellar: :any_skip_relocation, big_sur:        "3697f5718a21740869ac8aebe3361693261b54fd1894578cea6cadab52e01444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfdb5220be76889892b556d80bffb00177fb2ede64315c7198e4950a708e0e2c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.tf").write <<~EOS
      terraform {
        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 4"
          }
        }
      }

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
