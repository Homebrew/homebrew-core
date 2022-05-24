class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.36.2.tar.gz"
  sha256 "a5d4d9c036d9f671381c2feb3d84db3f293b53b89862bc1c72f327b6645a31d4"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b071d358d67c1d5d5e639b1f553aa1f762511dd878b822a0f8d42f5b0a6e2d6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bab30b420d44eb384c33e3f3f8079ac72a243e3bea300a85619d02fe7290665d"
    sha256 cellar: :any_skip_relocation, monterey:       "437acb8953f98a09edb8222c6496bf1013f1fc75e9b852488be964cb4af206f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "07dfcf7bd0435bb0cea9bc1593ae69c366dbc096e79cd314a58dec099174e590"
    sha256 cellar: :any_skip_relocation, catalina:       "96ccf781b15bfeae54e456e07f083e9ba2ad2ff97d6b56ecfa1ea685f6e383ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "489b86cc9ef0f588902e3cb91d18bb25523fb587adf527991cda82e69b2499b1"
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
