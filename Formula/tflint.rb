class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.13.1",
    :revision => "470fb17da7324f773e204ce56e5f1ded6fc9cf3c"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85654d379cea3827b04ca3030784aea6359cee2b106d9682f9d6858f4fea6aa8" => :catalina
    sha256 "a07992088f945c6b39844b71efc72f3a584fa2fb118332374cfd14c141af2fcb" => :mojave
    sha256 "a9b092875a63e93bd0437275be9907b89a9edc6150e167cae0811f2217044f68" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = "${var.aws_region}"
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
