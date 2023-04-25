class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.46.1.tar.gz"
  sha256 "a37f2095765a7706e7c2dbdd7f2cd7a14f11b1ff2b7186c61f92c6414d729932"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68959fb90a894a2f7bf605152f7ac6ce38b77177bae1cf065482eb8c11c6e536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68959fb90a894a2f7bf605152f7ac6ce38b77177bae1cf065482eb8c11c6e536"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68959fb90a894a2f7bf605152f7ac6ce38b77177bae1cf065482eb8c11c6e536"
    sha256 cellar: :any_skip_relocation, ventura:        "a80ac4039c232f354f9a555f0e24dcfaa9924760742fa303ae730c76dec27b91"
    sha256 cellar: :any_skip_relocation, monterey:       "a80ac4039c232f354f9a555f0e24dcfaa9924760742fa303ae730c76dec27b91"
    sha256 cellar: :any_skip_relocation, big_sur:        "a80ac4039c232f354f9a555f0e24dcfaa9924760742fa303ae730c76dec27b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ead72ab90f10982dd99f1722f08956d19d54ca907dd7c0b1d349b6510350fa6"
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
