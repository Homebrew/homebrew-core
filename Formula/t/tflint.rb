class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "4a0c84fc4052de551f97e5c4b0b81f869e3ec708e4f27eff5157813c8b46fea3"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3faf7bf7be0821fd55f469752e001280c2d7458054a4097a5407c48b328e36c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3faf7bf7be0821fd55f469752e001280c2d7458054a4097a5407c48b328e36c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3faf7bf7be0821fd55f469752e001280c2d7458054a4097a5407c48b328e36c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd9145ca48e62e51327adbda4292eb8e57d2abe8f006ead9e84fc53019e627ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cac89f92f1b28e12254875907f90181b10ee783abc47575c8ea395dbe0258fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d92809ea4c977848d7c3d4f4130e2d4d9efb9ba52f46ad5d6f70811853cec6d"
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
