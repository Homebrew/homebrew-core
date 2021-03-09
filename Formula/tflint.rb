class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.25.0.tar.gz"
  sha256 "9ea456246a4bb5224936da21edfb7390c225941894b6baf788816896f5c885f2"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1c38ccb89b4c34bd6e661462bc5b600d026aec475ede5769fa508a11a7264b9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf2d75947a6cfded6056c73a1b6b16b7607c017576bd230628934180079d3810"
    sha256 cellar: :any_skip_relocation, catalina:      "f964d17cf4f6c53ae3aeae07bba8d047bf0d518f378905d55ec98df8e7966fb0"
    sha256 cellar: :any_skip_relocation, mojave:        "6273c170c56328b94d83966e219f9664488f7d95a5d21ea3ce9deb096c026bd7"
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
