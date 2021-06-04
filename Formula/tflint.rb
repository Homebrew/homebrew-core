class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.28.1.tar.gz"
  sha256 "83df9ebc95b7a1b126d2fdc79e83c3e1d749a94f16c7fc500270f97c59c69c9d"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be653f107dbca3c8e1b9aed283d5aadca322952ca3f9a909284bb9ecd03a983e"
    sha256 cellar: :any_skip_relocation, big_sur:       "13ea78a61e67850540e870e456a471930a67da022015d139fe463610eed20b0d"
    sha256 cellar: :any_skip_relocation, catalina:      "7b2f7fe336a67f23e64504b5cafbbaa68a3b07da842dd372481f1a8f025589f9"
    sha256 cellar: :any_skip_relocation, mojave:        "7a97903cdee429d8afab852c239c974957cc85e19d94ddc8cb1338abeb194817"
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
