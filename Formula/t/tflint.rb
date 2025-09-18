class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.59.1.tar.gz"
  sha256 "9b45910e897fd2028d748387abc781f13c57127bacde97b083aed2198c7b105d"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f873357d065fdce6b58511cc37b38ef5d36135e34d8c1a707b993bb8a26b786f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bdbbc0944d5f47051b969872a11095f31206e85bf3857a050ca80f44ff2d087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bdbbc0944d5f47051b969872a11095f31206e85bf3857a050ca80f44ff2d087"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bdbbc0944d5f47051b969872a11095f31206e85bf3857a050ca80f44ff2d087"
    sha256 cellar: :any_skip_relocation, sonoma:        "89252903c5ffb7006376c4aa2f14c4b0182fbf2c48b32e4af014685ef066b3bc"
    sha256 cellar: :any_skip_relocation, ventura:       "c8a04be9e66bc4e17b48527b62617cf41e3cd8551014697f3e80a587342e2c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fefd140e3739fa3794d2ba554aa010c220f3a703dce0259b032060d6e44c96b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.tf").write <<~HCL
      terraform {
        required_version = ">= 1.0"

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
    HCL

    # tflint returns exitstatus: 0 (no issues), 2 (errors occurred), 3 (no errors but issues found)
    assert_empty shell_output("#{bin}/tflint --filter=test.tf")
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
