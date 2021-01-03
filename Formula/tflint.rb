class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.23.0.tar.gz"
  sha256 "930ef0412493a69bdd9ab839064839b556c7d432174a84b205e16b6cf3cffb8b"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1bb900426c99c9439564fe13085ef03b4c14c4f7b9536b95102201f702caaa1" => :big_sur
    sha256 "89c84ccce95e7a03de41c2570ebec2b98ad10689ec48b2097eba464a01f27603" => :arm64_big_sur
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
