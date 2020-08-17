class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.19.0.tar.gz"
  sha256 "4b46119e34d21de156b69bcf05a6fe3c566984234732f9620964f106a4444797"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "86ec39017e08892387e5da39f7664522abb598010008b7880116efb5eeb91d7e" => :catalina
    sha256 "d221826e5599c064ea50bb2006d970b2d053c9f74a04de7a61120cb4b6dec652" => :mojave
    sha256 "deb5f3ff61e4e94751a46b632f2e86d66f6863b096dbd60ea61382548566f8ba" => :high_sierra
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
