class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.28.0.tar.gz"
  sha256 "bc80aac540bad91e1b239796854e200c4f2a19585874d5c4ce9c4de7dad5a81a"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60416acbbbbbd903cb257248f22a6e6fd0eff7a52354f91e9e06ec03769f0540"
    sha256 cellar: :any_skip_relocation, big_sur:       "c34f241ae6444929c141391e55607e801ca0d0e979f24e1cfafe8d2dad7e5fdc"
    sha256 cellar: :any_skip_relocation, catalina:      "8d07959124aef2243977861b574f497465e59535da4e31ec4cfef411e58b8d2e"
    sha256 cellar: :any_skip_relocation, mojave:        "cab5a37bff66751ac948d821297f5664bda1f7529c8d929d8c3d3939dce47c3b"
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
