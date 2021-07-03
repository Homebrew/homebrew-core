class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.30.0.tar.gz"
  sha256 "b9f49c96f2457427140507dec17d24821d73acf1d76dd9656e17827e87b479f2"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e060e0b20235adcee9ab0b4b6abde7a192eabdd77b3738a30674934183108d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "e01ac3515617dd70d63b7ec71581adfe52f2a9f6eff3ec531c1e7e6bd08db1a3"
    sha256 cellar: :any_skip_relocation, catalina:      "47f1cf2ae35d3e92408c4ac05681c3dee333f8ea5e76c683454e44be3316f1d2"
    sha256 cellar: :any_skip_relocation, mojave:        "bf07e18a2aded917879823ac1a1e240caeaa2995a587a1b61dc52570387b7331"
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
