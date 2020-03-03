class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.15.1",
    :revision => "2a68a623a5202c7e7cea24003b5ea05985435c79"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6167fdacb45b50ff8b6ec86fb50b6dfe5da4c682d50462c4487cc790c7d4f3c" => :catalina
    sha256 "e26ffa14cab4a6184eef0745f209ea74b587584d3270268696742afee2fbe5e3" => :mojave
    sha256 "821cdc8f6652534ff9d223d9bbc637ee09551baebd84ad8b5483956e65c2726b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tflint"
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
