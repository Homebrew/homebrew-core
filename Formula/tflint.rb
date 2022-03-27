class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.35.0.tar.gz"
  sha256 "0f8e3e501a51f95bee99d7dc00c522aebb7ec1d908b86b7a2e372aa727cf6193"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d764cd60856304c5c0b20057c0a391631f45cb4f9b9d1ea2edf5036a10dad3c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dbf07a1996733a32c42f1b4f9f21a87e38b3afa0e30d5825f56d9059f2766d8"
    sha256 cellar: :any_skip_relocation, monterey:       "4c270d5d051d5a40c659cc8c1669c190eb1c91fc4c94f18fff0c821f0dce18c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8de1f55ec5965dfe07ea46331e8fcf9224cd7e06860a2ec391856ea24338964b"
    sha256 cellar: :any_skip_relocation, catalina:       "40df6049fdb5e8fc2e7fbcb8343e8ea21c39b9033b45312b1ed6f9d0501ec405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74081a60f5dd9d545dd9fbfd5a3d4d8acc05cc21d2f12a19df03dcc615ac32d5"
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
