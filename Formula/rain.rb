class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.2.tar.gz"
  sha256 "c5004a0d63e09949d2d89f7368dda12e9bf137cc6804b3eaa35a5b1f55320010"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee409861c8f3213e26ed210872f07830b5b4713bf1bfcc3e4270e2ed28b1027b"
    sha256 cellar: :any_skip_relocation, big_sur:       "1b029d4b65a23c35710d2be8d75152700324277c06cbeefa916899f65c6ecfb4"
    sha256 cellar: :any_skip_relocation, catalina:      "58f0b35cfe7e5b60e4426acc38c40dab59c6e5c7ac0fc43322962f9df36b8e09"
    sha256 cellar: :any_skip_relocation, mojave:        "1a167e243d5e8e62165735649a2c1b204b0562742ae875e477f1d5dbb44ddae9"
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
