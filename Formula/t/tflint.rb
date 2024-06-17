class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "c39d08ab0a546dde16f5efa1119de922bc854bf330618e7193bd6e3c1ff37552"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "602f71e3555b196f18f15c045c50a616c672798d8a48721b6ff708b969705205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc22b2f6d4b2ff81138eef1a49ea8112ca51b0218ae5736ca5dd7baa06d8dfdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70985e0b6e5f36b3fc3cce959c16d8859147ab7678ae4b8b8fd0aa1fdbd977f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7848916862b23c90348504ae0fadd61bb43448f4fe5c1d6843dfdc8e2c6e3a37"
    sha256 cellar: :any_skip_relocation, ventura:        "c36ff608f79f4d033fbe1d38fcf29571307b94e64d0f912c46b5bf02b1c0b1db"
    sha256 cellar: :any_skip_relocation, monterey:       "89cb2743a1db69e1540e9697cea160a357cd6ef526ca03ae4ac8e7a1ab0b314f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dbdf3199878f3f474407a9e2dbf311bdeb97d0a22d55a981e778992a41405a2"
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
