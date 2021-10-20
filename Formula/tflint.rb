class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.33.0.tar.gz"
  sha256 "a204e2ae311b08cedcf31fd621a0913cc3cda0cf78b42a8475af309f72716337"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7122ce310a1f28e415ceca654a5005dbe15c81448e1313925af02fcf091d760"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1d123d8f7d573d79481f53c2c55b3ad639f5b209d8b825942f9ed14a75afa2a"
    sha256 cellar: :any_skip_relocation, catalina:      "5615729a9294309119849ce9fea940aff8dde3c9908cc970bafe74564f5b30cb"
    sha256 cellar: :any_skip_relocation, mojave:        "1a88287623635a3677c2d6fed8d35969243510eee6c5bd101c059cfc4c65f216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad368af593e2faeed667faf29d2074da7779899a5dd0fd3401ecf273ed802de0"
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
