class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "d78da52920e51f82615ba98f7e731300501b88232d8dca76597e511fc30634a0"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52cb3d7d792db127a4f73da2a6f513c37b3342432da5c0ab250c74e6bd5cf7de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52cb3d7d792db127a4f73da2a6f513c37b3342432da5c0ab250c74e6bd5cf7de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52cb3d7d792db127a4f73da2a6f513c37b3342432da5c0ab250c74e6bd5cf7de"
    sha256 cellar: :any_skip_relocation, sonoma:        "030eb91523bec952a790bce879bb2f34de47b1bf27e7cfa3797630778ffefa93"
    sha256 cellar: :any_skip_relocation, ventura:       "2bc1916b8892e7907e754320ac44e42b1bd4ef7e28f0fc31a86826410f43f360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1126deb219f3ae455b6a67f6afc80cb0c029e7c57d007acbc81be58e0391b1d"
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
