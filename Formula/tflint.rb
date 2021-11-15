class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.33.1.tar.gz"
  sha256 "9f45c099989e43ee89568cf3545fa0746245891d82035ee2d3457917711b6d5b"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e4b349183ae02cfdb9b33a2f82ace559362fcdc5fed3bee46706a8e76bb0ee8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c833fda37ccff5b0716128d2dd6f28922e9a8f206004ce9a0f60a50a6896e53"
    sha256 cellar: :any_skip_relocation, monterey:       "11c2b792b93116fa3950411d9ad3ff8c7b22a045d2e9c7a32ead2fb19355472c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c33b2dacae2aeea3a261e60b1a5a90c9510efe9d1d8ad9bca2ec6c5531db730"
    sha256 cellar: :any_skip_relocation, catalina:       "b8d1258fe2c4b2a78c765bba135e238c9420642268bbe8052e92f2084681002e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "152cff0bf10ed445d47df030eb9a9853a57efca443ed698c955477d9b0ed786e"
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
