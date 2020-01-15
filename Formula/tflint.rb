class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.13.4",
    :revision => "5a562ba4f82dc2bda691b0a39f8f8d04c18f6f05"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "405d8c1287aa2528044c95a77dbcc1f060baa5ac2b3d850ffe4ec99ee974aa1d" => :catalina
    sha256 "65bba6b9b8a3cb7e2e69b25399134a7913e2edc17ed330667b9d2846f48341c4" => :mojave
    sha256 "acf82a32a8b499e3182643b6f5e113fdbe7c327fb41b3de07b11e25e2b0a82cf" => :high_sierra
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
