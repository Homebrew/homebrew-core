class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.41.0.tar.gz"
  sha256 "5d1535e3a10d8edc403f06bac0035ae4d533a1b2127cb773c5941d84b0a1202b"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d27841ae337a4417fead8a0169a96a24f14452ddda1783f94b5e55fd7e5dfa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abb3dbc6d0693b9543925df76863e8f86810ca7b844107fee01b842273bdb507"
    sha256 cellar: :any_skip_relocation, monterey:       "32219b604c51b3306d99fde287c10baf393c8242e10d55b5a46d487eee41ac1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c4b7ccd5fd541604468bb85f590e2c9f1e78c249e72724bcddbb97ea462ca15"
    sha256 cellar: :any_skip_relocation, catalina:       "177a294a587aba1e2fea8a391adcddb42ee265b148e410704dec874e37d4573b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13b7a7f27914ee221cf683c981b4e45311f0037a271809cf1913b37e18dc4974"
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
