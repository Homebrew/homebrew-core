class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.50.3.tar.gz"
  sha256 "e90acdbf4cd1dc936e50b580ade53583baced53a93b3b01cee3e073b233ef8c5"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a8d12ac4206f95152d99d5d89412657e2bffda49d62d19fd6467f004c2fedeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1952f282f334004f48eba8009fc8ce33cd94d76708d21b5d0a6454846d9a9a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78e4aa041cb27ff8a624a721a95ae91d875ec4af282abc9c493a29153d23c8ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "14e5cf7f17e9becd239983ccbfcfd88a0bb09e1d0d3faa5ad466075d5b3a42c4"
    sha256 cellar: :any_skip_relocation, ventura:        "f7657392f25f4ec9ce91674fdd1121ce2399f0e33a613fdb66bdea5361c5408f"
    sha256 cellar: :any_skip_relocation, monterey:       "351b8d3e92eb3ca60e9e52cd97f2b210e8a90ac731f9abc0b96c65d18777c39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27cf7a7d358af860f1126100bafe343f7b891f8d27e748d7662bc7d4a46b92c"
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

    # tflint returns exitstatus: 0 (no issues), 2 (errors occurred), 3 (no errors but issues found)
    assert_empty shell_output("#{bin}/tflint --filter=test.tf")
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
