class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.41.0.tar.gz"
  sha256 "5d1535e3a10d8edc403f06bac0035ae4d533a1b2127cb773c5941d84b0a1202b"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "430efe1fee391688bdb01083b458cf5f4ab255519c0c7d0cca7a4c202f34243b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b730ec1f8ccd8af596321eff4851ce370672b19a6c4f7353808a28c7ccc0108"
    sha256 cellar: :any_skip_relocation, monterey:       "e4dbc11679dfb3c5ffdfe10dba9b5575f2dd3261dea3e3b0e9610a2f9bfe8100"
    sha256 cellar: :any_skip_relocation, big_sur:        "effdde2a1ca0b154732477ae7dafe31a01fd61748dd4ca5ae2625dc25d3891a2"
    sha256 cellar: :any_skip_relocation, catalina:       "329d364d227be7e9b76d298a34483e56eec5bc1d90ea69b7e836802d05cbe4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d10b7b5743c5f53c15876868ba9ddc5ffb5c87edffb388833b89478d7c1349d9"
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
