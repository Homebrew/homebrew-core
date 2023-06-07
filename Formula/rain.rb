class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.1.tar.gz"
  sha256 "9dd2062fc9c3bfc75759c116b6aabfd13694176f07bf9616c4c5acc5ff253eb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "315537648dc3be95f50bd6bab7b594d1fe9737a231e491b320f8e0c72af407ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "315537648dc3be95f50bd6bab7b594d1fe9737a231e491b320f8e0c72af407ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "315537648dc3be95f50bd6bab7b594d1fe9737a231e491b320f8e0c72af407ba"
    sha256 cellar: :any_skip_relocation, ventura:        "ca4dc2596890a8e3b549d5bb523cefa6c2aeb2f0368f0d8a1baf37254600617e"
    sha256 cellar: :any_skip_relocation, monterey:       "ca4dc2596890a8e3b549d5bb523cefa6c2aeb2f0368f0d8a1baf37254600617e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca4dc2596890a8e3b549d5bb523cefa6c2aeb2f0368f0d8a1baf37254600617e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e374e5d7e62d6655461dc0f61baf645b305207d3e305455bda00eceec3e2eae6"
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
