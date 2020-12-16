class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.22.0.tar.gz"
  sha256 "a67684904b52f53dc0d5cc26c35927323f458507cbc5abee19351736a955912d"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1bb900426c99c9439564fe13085ef03b4c14c4f7b9536b95102201f702caaa1" => :big_sur
    sha256 "a4f2c297aa4cf6ac0a66a8fde295d3143f3905cd997c349b7b24ad114e916468" => :catalina
    sha256 "f33e6f76fd641c31fe0685083f8c89bf472f4bdf8527bd7889fe9823420c6f78" => :mojave
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
