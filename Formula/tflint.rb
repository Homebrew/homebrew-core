class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.12.0",
    :revision => "013fedc107c0d6e1045952901041ab367f0f2a06"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44676ccfd2eab7b62e949d9244a0b40ed45df4cb1864ce4feb801a4076a7b69f" => :mojave
    sha256 "cffc8f1cfd97aef7142313b20a0e7fc0dedec87973f384c35edb426e24a46ba8" => :high_sierra
    sha256 "7c0c391c1397327633c9dcd96323cfe32e2572f9df8b2c82988b0a63ffa0af47" => :sierra
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
