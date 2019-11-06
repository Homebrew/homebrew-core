class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.12.1",
    :revision => "98b9b63f6d1bae0838165465db8b04613760e9e6"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a321c4c221d75e7438bf5f0066f7fb19bdba08bb4a8e1f7f9aba21c4378f1115" => :catalina
    sha256 "014a86cc46f23c52eab90b9679c40cfe2727d88dd9d1e85538ced3f0a36d3ff2" => :mojave
    sha256 "68b21e6af886c82e29e24b8892bb7be0f75ccc2861101748aa9c18b283c0b9e5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

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
