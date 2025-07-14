class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "2099bef1b47dc995ae531ebcc92a9e272206976740095b1cc897b3185ecd82bf"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24339a7eb6991d6fbe6109fc1e92db9228d2519a2f72c1bb621bc841557cdffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24339a7eb6991d6fbe6109fc1e92db9228d2519a2f72c1bb621bc841557cdffd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24339a7eb6991d6fbe6109fc1e92db9228d2519a2f72c1bb621bc841557cdffd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a48a5b625e1089a2a982ba9fc78f486bb7c6c4868c10deb103f0dfe0c9e8f790"
    sha256 cellar: :any_skip_relocation, ventura:       "73a38207dc2e8397cc59971e5533a3237cdda184e5ff6c24cb9a7a7747f69f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a71d83a6b89aae23bdee2f4b0b295d0e9eb26a5f319afff8479558300aba75c"
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
