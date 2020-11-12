class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.0.1.tar.gz"
  sha256 "77cdc31002755e638ab8721e988656642973d2115f8b32914ebc29e8cc9dc6b0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "46dc6c9859a50f9808384453d34d3f1424d08d3d21c062826e29fb8549968e92" => :catalina
    sha256 "e753441f3386634d0b31e67f31caafedcb2291f21f249f649cb32c752b0453f0" => :mojave
    sha256 "ba6425b263d3ab95baa5214d89b966bb3f481dc0fb7848dcb0a2b34f47e8a732" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/rain/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/rain fmt -v test.template").strip
  end
end
