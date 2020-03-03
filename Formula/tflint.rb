class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.15.1",
    :revision => "2a68a623a5202c7e7cea24003b5ea05985435c79"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e158c7b2506fbe6147f6427cdbabdce81b5f4882c75ee2d46d7004122c6f69b5" => :catalina
    sha256 "90d5e52171d056b3e836fb8c1a19b60bcfa29ab4c2ce3fcd0404386b296c3e99" => :mojave
    sha256 "816f0c2590828c20e46c8c54f287b6399619e1d2cd33c801e6d8c0104991d022" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tflint"
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
