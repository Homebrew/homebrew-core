class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.20.2.tar.gz"
  sha256 "5598d622ab19c2f6ebb4d18014dd2e9968ac7f0491ffc9e68b0baf9be1320801"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9b7b7fb907769f0120d324794bf83b4aec1f0195fd3aaf8dbbbe72dc3bd15af" => :catalina
    sha256 "8dad6a697d76605212efadd84f98a200a85bd65997f404b364fa4632138b8755" => :mojave
    sha256 "63e4351ea096dcdb744ed006b582feffe3c6a13dfbbd5db285c29d37b002706e" => :high_sierra
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
