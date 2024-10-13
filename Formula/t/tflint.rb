class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "22dd4644dd249b38b8cbb29bd4ca66aefa65a2d9dc38109a3ca5b428a4ba755b"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "73b206e4ee3b99d7cf2c351338127c11e0b4faa67ab52b3f50514488ae0ca561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7763ec46d1655646c80304ba4f247fe77e34fc152ad2984d1dd62f3fa92cbff2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7763ec46d1655646c80304ba4f247fe77e34fc152ad2984d1dd62f3fa92cbff2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7763ec46d1655646c80304ba4f247fe77e34fc152ad2984d1dd62f3fa92cbff2"
    sha256 cellar: :any_skip_relocation, sonoma:         "032e6c2238a021d44aabea16fc2450566d94846ef97b4a74a73e6ddfa7b18371"
    sha256 cellar: :any_skip_relocation, ventura:        "032e6c2238a021d44aabea16fc2450566d94846ef97b4a74a73e6ddfa7b18371"
    sha256 cellar: :any_skip_relocation, monterey:       "032e6c2238a021d44aabea16fc2450566d94846ef97b4a74a73e6ddfa7b18371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "767ac7a588e298788bc762d3290cffbc6cd8ba364426d7f11a7f383381d1028e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.tf").write <<~EOS
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
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occurred), 3 (no errors but issues found)
    assert_empty shell_output("#{bin}/tflint --filter=test.tf")
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
