class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.12.1",
    :revision => "98b9b63f6d1bae0838165465db8b04613760e9e6"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5c626dad3ef2a5da7afd27c25ba949cb7601038e2127ea668e46064fabfa940" => :catalina
    sha256 "76efb18b86366c93d87450c9109a7a6913ac270e4090a5eb8044b68ff6561317" => :mojave
    sha256 "8c887a1d7d19a760eb1246fb1187726e85e01254fd323f4f75759bf47cc910bd" => :high_sierra
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
