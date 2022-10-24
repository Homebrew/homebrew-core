class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.42.1.tar.gz"
  sha256 "abd586e4e545a7e29ae28f534745215ba7813ad6ed9c62f50d410f2170dde31b"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d83d1fea37345145637b730feb4d04423e553816469c8ed717a99c19e53239ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeacd1d3c6977cc8a2cf3b45e2c6911953301651f8170c1b38b4e0312018c1da"
    sha256 cellar: :any_skip_relocation, monterey:       "3c2dba42c5d0f944169eac2a255310ab035e29f0519abffb9f59f7ae870820ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "a31d16934c3515cd473bcf3353bf3d64c25e370f07c433e69c9d05fb7f269a55"
    sha256 cellar: :any_skip_relocation, catalina:       "bb0dcba78e6bfdad15e2442e4a4d659b34478ba7daf7a644c3f765923059bd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ec6d9e7bfb8e75e7e0f540ffa01e4409e2ceee9b3b165841bae688941fc7af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
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
