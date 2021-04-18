class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.27.0.tar.gz"
  sha256 "c219c0651376b61846de4892dc8f269a2b49032b6326bb0fb9a400f6e86042ad"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31c6841bdfec7783930e8fe520af974272f050011c4447159c33b1393a72ae64"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf35919ade53799c4de1b4a254b542bc72d83b4e00542aab8af8e85e8acf7a21"
    sha256 cellar: :any_skip_relocation, catalina:      "11e84db22b09c2b8dbd1bf3503cb84d2aaf87da7b2333b09af561e7e73339835"
    sha256 cellar: :any_skip_relocation, mojave:        "6444692e0a0742d0269b7a9bffa6c78150c5efa26ffeba120e255434021119a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
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
