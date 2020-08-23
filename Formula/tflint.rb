class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.19.0.tar.gz"
  sha256 "4b46119e34d21de156b69bcf05a6fe3c566984234732f9620964f106a4444797"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73a636aae7e2114721acf7109e1ee6731a9af94ec4702e89edbdfdc544dd7430" => :catalina
    sha256 "e8b755f1789f6e1bfff547cf8a7063dee3ac7b8ddd165c1e231212f4318062ba" => :mojave
    sha256 "6f7a4e70bf697f1e4c6749bb6b46c8fa08bbf2f01ef94967db9113d0a8eae1ba" => :high_sierra
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
