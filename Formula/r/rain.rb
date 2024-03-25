class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "6e7a87913f963afc349c8ee9da5ffa6732856df6eef63c930db72c3de1812f7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7410427c4a1f579209b236cba5048e7ed708c6d5411beca04f5d1de77c53c72e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88968eda3e70b1afe143ce198d8b20ba15b0fe1acfa7b0ac8b7479583e3831e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d73d795354d9ac5be4beb21238d358ac0bbf9dcaab90f72613ef09ccab9b043"
    sha256 cellar: :any_skip_relocation, sonoma:         "0840189936f73432e232f49e985dba2ce4c03c0bcc3eba65b0011951d8a7ea26"
    sha256 cellar: :any_skip_relocation, ventura:        "7c7440ad69eaee7d2c25ce0d8f3badfae909af165a8ce7fc0a0c2ab0d1bd6b5c"
    sha256 cellar: :any_skip_relocation, monterey:       "a59d0fe1b9dbb4f3a02cbcda71a3856f5b1255ec26c9143d3b75d0adf0ecd877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b28efc429b59510babac7844f86e22b6f34203d346cd02ff7ad9406b1994aff"
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
