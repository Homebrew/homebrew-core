class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.31.0.tar.gz"
  sha256 "3a8a3aeae3d4b09df3c5c9eed07c2da1680191e6493c31642e0fa3f518c341da"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f090d9ea04f0967dc47c875d2eab963d557f58ad5ecaba755d4b574b612822a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffa609a55dfc0539a62fd2049fc6bd7e5c06d9d66f213b574fee3edda0ba5a7a"
    sha256 cellar: :any_skip_relocation, catalina:      "ee311fb2c37c66485ececcd1b5f9eceb3e8d1714a1b654bdd9f68c42da747e2f"
    sha256 cellar: :any_skip_relocation, mojave:        "960e03e591a258382a0cd00e688d3c80eef3a67630b8349983b2d66dae78d2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e0113630d1707f8f596ff92565c7e950a31b858bde432c3a3159710851f3d5"
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
