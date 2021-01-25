class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.23.1.tar.gz"
  sha256 "aa665fda9377514f4fcf4c72d5fdde8d02027fc6d2283074ad2527e2df5779ed"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67955f3f223fe6b3dfbd97e158b90aea3583095a057a4a1dea0719d3aed7b5cd" => :big_sur
    sha256 "7c0633a1dda23616f8e593bb20b80568855020baf1b80733d3bb023d7e945342" => :arm64_big_sur
    sha256 "e92e2d2e3f5e9a959e22567b84f05264e6410d9370027a9608662ccceeee617d" => :catalina
    sha256 "45c4b7cc59b257d1bcb522a83e0979c0d721c7f20b6ce160f9ed1d31d15628be" => :mojave
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
