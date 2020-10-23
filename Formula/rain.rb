class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v0.10.1.tar.gz"
  sha256 "5b3a8c98a0592567140ff516722cc1e1c36141b3d0caad20a066c957228c196f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3972a324af4785ea1faced508ac6cf4051fce1e3590d3e384030a5502f20108" => :catalina
    sha256 "23ceceeaefb5684331c69143a968459aec9a665a11ff7c9b2bd25370b1fa7c05" => :mojave
    sha256 "41fc5a0444c0ec63e2b70ee2705f673c1cbb8a62da07d0b57fe60c776e7977f7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: ok", shell_output("#{bin}/rain check test.template").strip
  end
end
