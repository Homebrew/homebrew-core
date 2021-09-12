class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.32.1.tar.gz"
  sha256 "4c1004cb01f509b7c338527610dcbda2f8e888c3fe9557a4e8886e6cd1e1853f"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28c3e9b1090a12e105ad7fc4d3a10088c433242185b712822e356e832d5bb9ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "37d03043409c9deb2d89ba60c564ddee3d1cee94d5a6947d412f8fd82e7e4a7d"
    sha256 cellar: :any_skip_relocation, catalina:      "216db9300d2a5015e149a7f784a469a104a3fa318ba6f1cc4dd23c7ab4cb583e"
    sha256 cellar: :any_skip_relocation, mojave:        "973206942fd57b39a9f9f69cbc9c79e929fdc1145afacb03cc7c4fb0fb9f9f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10e69f3f47921d5991ab51f924fa6a0fd9ee82cfd9e723b14270cfa02748cc9e"
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
