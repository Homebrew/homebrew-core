class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.0.1.tar.gz"
  sha256 "77cdc31002755e638ab8721e988656642973d2115f8b32914ebc29e8cc9dc6b0"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e69463fc1800789c8b6a02560597aeab9e5f5bbf2dd555f2adf68bab49ae5ec8" => :big_sur
    sha256 "b4539bb5e88e61706954b63cc0e330755324e0baee5d78ad63b5e2248b250af8" => :catalina
    sha256 "c48a837ff273ca1f91b11beb8fd65b33edb83e340d73d80b4038f5c432a6801c" => :mojave
    sha256 "d78bf038a48d0618a2263e72e4acd8e3a1ff10340974d585fd826a35c7b8c0fa" => :high_sierra
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
