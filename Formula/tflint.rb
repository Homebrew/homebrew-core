class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.34.0.tar.gz"
  sha256 "3377eb16212048db5b32fecfd0df0fe52f3aa3fd712bf4403279f6e01bae24b5"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed2be5d2c2c5000196a20ba21ba6db85e8660307e95a1352665f5d7b36dc596f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dda253afa8498992f9b274ab226503880db5106de9cf9694c4135354934811f7"
    sha256 cellar: :any_skip_relocation, monterey:       "3e8a9a1707274f5c6663af07a338a3e6906dec1240272eec2cd21c76a1effb3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "08b21f35c0337072b614828aa5e81e71f5d814cba258525a558979a849f46aac"
    sha256 cellar: :any_skip_relocation, catalina:       "9a553fe052893021a07bf33db8fc3157fdacc9203e05d078ed8c27bdda98d0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b32155bc34844d2cd30f4ffc86309b403eada02981afc48addd9f3ea67580dca"
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
