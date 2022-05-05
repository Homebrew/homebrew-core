class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.36.1.tar.gz"
  sha256 "e05761530f4efdfd9d4fc5efa3f4eaa1e38e2fa49ae28b84dde31c47779c399f"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c23de3b499efa81b0a4081753a30957e15f70b4b2afa0a6ab3877547824b715f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52c748822765cd0297d03b342e1ed98b0ee3b6b9c55d84b39bf0ed4f4ba11b5a"
    sha256 cellar: :any_skip_relocation, monterey:       "a1ca77ae532bd6598e38fc4f5dc0d9dcadbd83eadc6ccfb69134801ca7be68b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4834eac7ce0ae3aa3d90040b5af567b097336645b833be951d6906d5b825eac3"
    sha256 cellar: :any_skip_relocation, catalina:       "402839db919b713692a1c7283abea855d8ade0546eb82fd294dfe9e87d325513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30aedcf705712dd75c4814703d97c44fbb6c5736b8f9b4994f21954eb0444caf"
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
