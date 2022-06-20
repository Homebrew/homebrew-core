class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.38.0.tar.gz"
  sha256 "73c6174fe0b31c152564801c20109b1e3a1798f58d1ca74e12668b4fe135dec6"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7884bcf751778ee7eab599ebf80090f0d5aeac639531e67ae90653c624f29a50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89daa072539cdfc2bb7c0c8b423230c767f333f97a5d844308af7a117a53cbfd"
    sha256 cellar: :any_skip_relocation, monterey:       "94902641bde5c01a946e3b0d1f8ef4a6a5ed9c156aaa4ca13b40e0d188df7769"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b1e1d8b62d84bad8c00371f4c89fe0e55da972bdcbed715f7c4f6bd0ceb47fc"
    sha256 cellar: :any_skip_relocation, catalina:       "a86b8cbc63e935917ec5cb97a44af0b3bffa14ba6f3806e3df0884550cb00366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0f00f0747f73d7f502960ddbb160bfeabf49b7c65d465fcdb4814dbc2bf96a"
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
