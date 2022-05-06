class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.36.2.tar.gz"
  sha256 "a5d4d9c036d9f671381c2feb3d84db3f293b53b89862bc1c72f327b6645a31d4"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac680c9e01682c7a3c3daf69c98cf92b6d2294a33a30ed185e1a32ed57ca1a24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1c2647a0c1231aaa231c40fa2e8466bf53ec5a744868559fb3f4016fbcbe49a"
    sha256 cellar: :any_skip_relocation, monterey:       "1a075d579254824d66d53905b9918c8c5eebcaf02db850b7df1ae0ee0c36bb98"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f3fda1d77a522ff79bfbca4941f85c222e0ee3585fc274f12b673a45e255986"
    sha256 cellar: :any_skip_relocation, catalina:       "f9a4aa793b18a696faaa0fe2e958c6f87069fb9eba35239fb965aae0d29d0279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb0df493ce623a15f087422eeb772daca4222091f174b0b5278f3093ce3ecc4"
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
