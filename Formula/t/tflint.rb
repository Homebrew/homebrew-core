class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "c65176cfc5d9c7291b1f240e469670bf222baf8fdf2b9b3555bf0b6fce74a4c7"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f334670b74f8d6ec47e6cb8e21784753fba04f87a11b6d3743190463eff27615"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f334670b74f8d6ec47e6cb8e21784753fba04f87a11b6d3743190463eff27615"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f334670b74f8d6ec47e6cb8e21784753fba04f87a11b6d3743190463eff27615"
    sha256 cellar: :any_skip_relocation, sonoma:        "6766f0bb9933eece28ca9b795587baaf14e9894488709892fc84980f39dd2bee"
    sha256 cellar: :any_skip_relocation, ventura:       "e14cdcd73610c1a3ccd977dbd843b4926d683793b91c0b115fcc04873b37e66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ce462994f711becd98a8fdd25766fe30605dcb07663d971144b163c148d956"
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
