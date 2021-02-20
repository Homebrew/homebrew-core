class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.24.1.tar.gz"
  sha256 "aaabeca85020c518189509b1628b83cf52f2749579f308ff4bcdff8a10bb3b99"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f59f8f1abf34e6bacf352453235a9f83da8e31e06db8ab33ba1a016c0faa0517"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae2af08ef4a81aaa4396631d42aa4dc5f789ae3cccbef346223700c985cdd928"
    sha256 cellar: :any_skip_relocation, catalina:      "caa165af722c3bfdd6e38d5c6617d75d0c7c91019eacbb74f2c536eda3947f4c"
    sha256 cellar: :any_skip_relocation, mojave:        "6276be551e92dbd5d91047b0a6b0fe09f9d09994913944ab7608efd650ebc8dd"
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
