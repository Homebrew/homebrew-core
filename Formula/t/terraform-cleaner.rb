class TerraformCleaner < Formula
  desc "Tiny utility which detects unused variables in your terraform modules"
  homepage "https://github.com/sylwit/terraform-cleaner"
  url "https://github.com/sylwit/terraform-cleaner/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "61628133831ec667aa37cd5fc1a34a3a2c31e4e997d5f41fdf380fe3e017ab55"
  license "MIT"
  head "https://github.com/sylwit/terraform-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0df9454cbf8c02fd4ac90be3d5b5b6df738794407bf3f5e865ea9e408051a377"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67a332100916e31bdbef196c2f08954acccdfaf069c23c84d62bcb51d8452066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67a332100916e31bdbef196c2f08954acccdfaf069c23c84d62bcb51d8452066"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67a332100916e31bdbef196c2f08954acccdfaf069c23c84d62bcb51d8452066"
    sha256 cellar: :any_skip_relocation, sonoma:        "6837b7386c38bb8a93e922cf9889e5a95e90e15469111b110e4316802d714363"
    sha256 cellar: :any_skip_relocation, ventura:       "6837b7386c38bb8a93e922cf9889e5a95e90e15469111b110e4316802d714363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "729f4ad39999e1d2da4700bcb7a49f955d7566290de3cbe80114b1999ce45201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f64a821e096cd1dd000e4123dd6dd917905d21ba089da6d9b998f4c3920800f"
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
            version = "~> 5"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }

      variable "aws_region" {
        type    = string
        default = "us-east-1"
      }

      variable "foo" {
        type    = string
        default = "unused"
      }
    HCL

    output = shell_output("#{bin}/terraform-cleaner --unused-only")
    assert_equal <<~EOS.chomp, output

       🚀 Module: .
       👉 1 variables found
      foo : 0

      1 modules processed
    EOS
  end
end
