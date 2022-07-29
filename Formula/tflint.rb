class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.39.1.tar.gz"
  sha256 "a6564ef7156d5a4942e761f85985201c319d93527191d4663c70c064ca9edf4f"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cbbe52194299641b45eb21b4a9dbabc4d5c1006856636ba40288f3e58a648b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c52ea3847680826bc479a25f1453c21d34323f312bdf36075eae30430d1a2d5"
    sha256 cellar: :any_skip_relocation, monterey:       "c9a082f6e534813b24a888856fade6cce40cdfd68d5f73363d509127c0709fe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d051fdc36cc8bc39b01da7334870c2519ba7d9067109af4d38459f5ad62d50e"
    sha256 cellar: :any_skip_relocation, catalina:       "44c4835c18b921252ec62ada18a8e1535e25ac58a6b19d2cd4444786d71cd842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc6d0f49694baeeb44a661673a51649c66144fcc354417fad73144957e4a629b"
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
