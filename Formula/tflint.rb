class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.39.2.tar.gz"
  sha256 "545c9cab5006fa5e38649682424f7eb920df394f0803aae81547bc47d00821bf"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d19898f86d4754a77058689ac292b41d18fc0e1af9b4ad683b170c0cc97fe3b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48f619840b95ae7f71058abe042fd9bac02662446df54f6add842f3d5f8efead"
    sha256 cellar: :any_skip_relocation, monterey:       "2452332506afdb7d07d86232d760be3d9348701ee5a0e0f222530a5c1ab8a25f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c05923096e53d2ac65087adfab211b9255822957b439ef2b65c22104e5daf574"
    sha256 cellar: :any_skip_relocation, catalina:       "c0ecbac48d4c4953f882c84adf2bb675f937ec9c85ee7428f311cde989b26ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c14b42a3a5bd8a9051f2d8ebdbe645588f1428f35e7b2f233cc06fda2f0e8bc"
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
