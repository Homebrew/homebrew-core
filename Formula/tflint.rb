class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.20.3.tar.gz"
  sha256 "a375bdcae4276e39607a026da9b50ddca6656586baed2c7c667ed77acf570985"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7930b07af3479a15c068518f97f9064a1baa9cec4c1a604ab519b1a28eb8fab" => :catalina
    sha256 "32d10ac434538fbaa8927c78a2b01406071af79c4ab5da736db3f47629831c42" => :mojave
    sha256 "a44edc90914c6e3d02742b0fdbc167a6f7681065dab8464092ccdedf5706b765" => :high_sierra
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
