class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.43.0.tar.gz"
  sha256 "9b49b668370d2e00525100dd6b092350fa6c52a6c0854cb2a8260fd4a0112ec5"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcf79b29c996eba21372bcbceb2d313017d118b5be1a35fd9f19c8c27ea2279b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34526ace3a0d24a3540ef7f46b1a8cee3b2dbae94eb749b74a1c9bd4cf051356"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7d05c32258e446c957ccb4d466501d4cb18992fd34154ca3317e88f2581f16f"
    sha256 cellar: :any_skip_relocation, ventura:        "5a10c8683f10eb007a56946b5793257126acd20d1424aff76748acc26d089dbe"
    sha256 cellar: :any_skip_relocation, monterey:       "7ec114d8d3182e115dd4123e349b227840e1573e0bfd55b4dbd680990c8d819a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcc6fd68494c1830bbe7fb700c25188af807bf9c467d2f074bab8954fd48e78a"
    sha256 cellar: :any_skip_relocation, catalina:       "08c870727ae55df0fe81781cd5ad3d7faa68b0ae7d65feda75f460fb1cc986dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b304cfd9c3ac0f40e3c78ef4495c77d0ab4550d7a683f3c8286bf503a9e8616"
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
