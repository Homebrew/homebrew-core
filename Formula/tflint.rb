class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.16.1.tar.gz"
  sha256 "0c44c0d1e648da72d840bd58e7e56755f354484be1f7ea8ac715a2ba2e447f50"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "780e554cfb70cfc310aa883a5586ae2d398e9e822b5e0361ad2550b5cc50e5d1" => :catalina
    sha256 "71f827967a746ff284da531604ae0481605802bcd3415c6c5d555593d8215996" => :mojave
    sha256 "9ac781f946ea85da3e85791b967f9fcb72e317e6184420ccd9346b1ca8df9c2e" => :high_sierra
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
