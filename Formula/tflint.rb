class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.15.3.tar.gz"
  sha256 "878498373f45e6a34a3e1016339309ba973d7f13887430ec9674d745a751e170"
  revision 1
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92e921c2a56f43033cb16de281a6f0b2701cf717fab71d687833570f8b650479" => :catalina
    sha256 "2327c3e983c8af87448c77b74be7abbc2cfcd160a39f24a5fd3aaf8585750af0" => :mojave
    sha256 "91d0c9090017907240b65392a5e7a1906dd510c2dda21cf84eac9d0e2f85bd73" => :high_sierra
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
