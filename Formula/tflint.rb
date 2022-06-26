class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.38.1.tar.gz"
  sha256 "615b114cc0f740d34bdd2b2e148810d1a91ceeeda6a07bfce66f8b94661cf8fb"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57cfe7e2e391cf6435f93ba5469912f6e1e20d5c076926b46a947183a7c4977b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e216efc4fd6b3e3c7d6ba04c4fb9d2cd16669172e7dafa7a865e36c44a31a705"
    sha256 cellar: :any_skip_relocation, monterey:       "987b4abc3d650a09ce00b3374ad2ca405b3c6c3fb48eb1b9e3a15572be0271cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "baaacea1ae845872b7df74ba6ac3ddbc1be73f045e2c909e2f15b62a3b34cb3a"
    sha256 cellar: :any_skip_relocation, catalina:       "aa1b7242f06cdfd76266e9e0d49420c9138cfc1debf7986ecd36842370b94270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799d8c370bfd7a3c2dfc25ad4b9ff5c1c27603f812cc313149b8e4df6d990e06"
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
