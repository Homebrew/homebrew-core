class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.11.2",
    :revision => "08afbfa51ed6cbd4bf6d41c43de8910515bb098b"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ceb2dfc4b77a86616be7babfddc013f3bdeae9b6fd60f4f318680c7fd133d8b4" => :mojave
    sha256 "bca39eb983b366f3c16f6ce08e9cee1b39e584fed8338fef93eefbcb1565d3ea" => :high_sierra
    sha256 "b20c9e9b857dd39b616e072b0ccadbc97ee0cbe4d657104bd9d145d9f543c51d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/wata727/tflint"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"tflint"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = "${var.aws_region}"
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
