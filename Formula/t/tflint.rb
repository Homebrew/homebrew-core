class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "d99c9eb3003375a4220607e1b479c9292450fd2c576549b1887f1c7259730e17"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74880fb58c8251cc4cef72ddf8bfdb4eee0910c5d9f480f9c8bbf796c7bd2564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74880fb58c8251cc4cef72ddf8bfdb4eee0910c5d9f480f9c8bbf796c7bd2564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74880fb58c8251cc4cef72ddf8bfdb4eee0910c5d9f480f9c8bbf796c7bd2564"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ef66af3e849610ac2664876527efe4783457d8ec64d61d373963aa51204da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d757d8cce83666f2715232cf720dff1036cd5861081995f9463e660b5c9bdcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a28d44e653de43ef61c1a5b9c041c612aa1833965a9767af85d49b5fcfb492"
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
