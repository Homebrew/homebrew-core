class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v0.10.1.tar.gz"
  sha256 "5b3a8c98a0592567140ff516722cc1e1c36141b3d0caad20a066c957228c196f"
  license "Apache-2.0"

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
    assert_equal "test.template: ok", shell_output("rain check test.template").strip
  end
end
