class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "3359b66294fbc39c079071b421ff1c63b2897f87fccb8dd5067ee8759b8b6db4"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c1b715d04860d9de60920ab4b7e87ff1e1bb935a126ee145e5c76b707a163df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c1b715d04860d9de60920ab4b7e87ff1e1bb935a126ee145e5c76b707a163df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c1b715d04860d9de60920ab4b7e87ff1e1bb935a126ee145e5c76b707a163df"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dac87b113ca6778cea4d95c5809ae9ef1a5d29fd6987fbffaae59d7b1153871"
    sha256 cellar: :any_skip_relocation, ventura:       "25bcccc63c8263d03a9f9d9f6673ccbcaf9b2f0135add0ece64e19a38d822ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0d73e847e1430e9c410ca18edb3785b3f35a4d81d0e9e15489cafc93f5840b"
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
