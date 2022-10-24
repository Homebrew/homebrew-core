class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.42.1.tar.gz"
  sha256 "abd586e4e545a7e29ae28f534745215ba7813ad6ed9c62f50d410f2170dde31b"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66b2ff597fd33bda57a3a3d3f7a1dd93626d0161e1c67d2588636ccbb5a6fa69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca88c44ae76a070d7126f72784c55cfed68c79d30016369a348056618f09dbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ff79886cc220203be428220f4ddfb671a0e8996f93ffe8e83a166d878f56cbd"
    sha256 cellar: :any_skip_relocation, monterey:       "059e85d692ddf42d385815d74aa895002f086565fe553a7ad2385d5a44066991"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2e1be3bce845ecef445efa899e8f6bc0b295a60cda63812f70f446109cd0610"
    sha256 cellar: :any_skip_relocation, catalina:       "94844bc6918b4581e4c0277d869f0b4b62cdad3d2a4239ec29a8afd8cfd4908c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9310f6a0738a2847f406b2c867fd5354da4587c50a37709e8c97ca738071628"
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
