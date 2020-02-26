class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.15.0",
    :revision => "869c0a04c14ac316af0153ebc665b8a41e17ece5"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9f0fc2a91060f1de08e5232b5aae15c14bd4602748238657584ec40a1dae8e9" => :catalina
    sha256 "7b902fba389828da3898acefd4f89e01b04b2badddba472d570e4f58b2e3e7ff" => :mojave
    sha256 "deb2cde32589e6e282f8ef2e3d7218537f4fe8e70b7bb85fa16b1e4fe2e5dabb" => :high_sierra
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
