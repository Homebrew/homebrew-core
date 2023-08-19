class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.47.0.tar.gz"
  sha256 "2e9cefebb18e4fb15faa217dd2005feda2fdcabb7948d1298773b8458bb04abe"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07e692e18c8938360b4212eaefb563a9f7e6cc3c5619a4f1c459288760c31fc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07e692e18c8938360b4212eaefb563a9f7e6cc3c5619a4f1c459288760c31fc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07e692e18c8938360b4212eaefb563a9f7e6cc3c5619a4f1c459288760c31fc7"
    sha256 cellar: :any_skip_relocation, ventura:        "27cb821e54f3b5e9a8963d32d6a56a6837d566311cd464bd80e9b680889f7af3"
    sha256 cellar: :any_skip_relocation, monterey:       "27cb821e54f3b5e9a8963d32d6a56a6837d566311cd464bd80e9b680889f7af3"
    sha256 cellar: :any_skip_relocation, big_sur:        "27cb821e54f3b5e9a8963d32d6a56a6837d566311cd464bd80e9b680889f7af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b1b97db3839a0c38548867520132ebf2b676d0b3f3b83ea2c754d340ac641f"
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
