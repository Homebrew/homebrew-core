class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.35.0.tar.gz"
  sha256 "0f8e3e501a51f95bee99d7dc00c522aebb7ec1d908b86b7a2e372aa727cf6193"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6adbb9521a0edff3c7a0cc4eb8e6796aef138d91efda0dcf8993f06962558868"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7712be10a5035dc5c9ec66406cfed66b4a34d4ecad8762db8409a36cc7266865"
    sha256 cellar: :any_skip_relocation, monterey:       "11fb9f7a18c876973dfa0108c38ab736ee4b5d189d5859c61f2a2152c4c04647"
    sha256 cellar: :any_skip_relocation, big_sur:        "39c9104f8dc3bd5c54289119b74c36b90ffcefcfb7ef0d619a9fe5d462a55a60"
    sha256 cellar: :any_skip_relocation, catalina:       "7b6022ba10225581003ea9c9d07121a15812c2cd63072b71de6002cd47deef1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "132b774e4917a27039a8cdc599d6bef9ad8022dcf6429c3d5a2bdf22a9a6cae2"
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
