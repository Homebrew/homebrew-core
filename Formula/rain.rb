class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.0.3.tar.gz"
  sha256 "d79afec4780e6fd9561793a40f5d080d91edf7ea5e3fbeb7c5f8ad6accdd812f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "edf9b2482b39525644b682922d1653deeeb2fbed49b35ba5a40faa0baced1bcc" => :big_sur
    sha256 "988710d2ad8fe440006db2b7308570e2f0d16cb5697d0e2bae222138cf76be91" => :catalina
    sha256 "15924ace4c68f471cbc6f4d89d9657cba5033bbb83f85e5dcac8039b7f7c98d3" => :mojave
    sha256 "10d098488c17198175e8494441c5313a93a89dc14c4eefd3530b78d9755051f8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/rain/main.go"
    bash_completion.install "docs/bash_completion.sh"
    zsh_completion.install "docs/zsh_completion.sh"
  end

  def caveats
    <<~EOS
      Deploying CloudFormation stacks with rain requires the AWS CLI to be installed.
      All other functionality works without the AWS CLI.
    EOS
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
