class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.45.0.tar.gz"
  sha256 "74d2852d7f20535458bad329c128c189183c8ba1944deed38c4b820798279b6e"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f4762de60a251f9fa05119e489bdf1264c989daeba622774626d9c1bc31058e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b02920e9342417b538f370b96122853395665c3aa3b699ad53dc23bd4453d19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24453e9ab7843b872aa3709445ed1b83087bd4e93a228bcb159f525a92ef2334"
    sha256 cellar: :any_skip_relocation, ventura:        "126e2faaf574878be00df7a2016c7fcc08e503fd98194a1cd7040e2af6452fcf"
    sha256 cellar: :any_skip_relocation, monterey:       "6527ae50e2dbbaf6c9f66b51a61e45cb263b688de6f09e9a9a49ded243b7a37c"
    sha256 cellar: :any_skip_relocation, big_sur:        "53fec6689ad9640ee9b71c41b687fb70e86ca2e6c57778ced3091a8786eb3e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aca43705ae7f4c48839879362934c5e84ecdbce2b8276ed11b20da46efce33f"
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

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
