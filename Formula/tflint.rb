class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.40.1.tar.gz"
  sha256 "cc7612386cb63a72a6b49e70e71996c5d6504f66538ad9e9c9a8d374723aa0a4"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45ff2532cc4087f25f6612090e8efd667ee52287a3e6a7c69c22a3491592ecd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36d39d4251d59e104f833df3631b14fb0f2e9c8d06a0b30f737c5b7687f4fc0b"
    sha256 cellar: :any_skip_relocation, monterey:       "04f7701f29917bc4c77eac6dc543c6e0e9a54fc7f30d6600539fb99c724999f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4facd3e84152a2280510ca0fd9e58df30aa717867e3988c59ea2f051fd79773"
    sha256 cellar: :any_skip_relocation, catalina:       "20993b0ab0322bce5d7489744cbc09ca8e04f3c605f980465d13313ce4ea8424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "289b397e641f76cff0528bb064f5b9085400b52345c7fe54a3cb087b305be399"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
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

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
