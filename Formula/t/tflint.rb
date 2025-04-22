class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "7af652453d0eaac07eea47a89081a49998688d8dd50d9bfbd68d06916892b6ad"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b382992f625674270d571c3671a7a979fcac4e09df300931dd69884d4a0baabd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b382992f625674270d571c3671a7a979fcac4e09df300931dd69884d4a0baabd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b382992f625674270d571c3671a7a979fcac4e09df300931dd69884d4a0baabd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b0734841a610733aa27860eb88907f2c7cc1fbd6b75312cc00bde8375557cdf"
    sha256 cellar: :any_skip_relocation, ventura:       "f39fc30d2eaef4ecb7a6f0ebf3bf6b6b01e905e95454ef64efec59ebfadc0a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd6ddd288cee43419f151e2bec74c4ba9390f86541cfda50de42a7fde653fb5"
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
