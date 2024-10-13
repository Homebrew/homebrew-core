class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "0c73ddedd02317ec2cc80c183c0c60a6fc871aaff58602623d4e17668054aa8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9174b6846184d7f22b6355dec5e8805ab0abc15e956d144ac6a1db657e773b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa6d8cd37964f23aacdc5c7e2be10e06d3e920567f04e29e1c766dedfcc588e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "663577a44b7edb71cb6203a01583344a713377a4ab584d227b87f6e2dcf798f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e1667e496d7a0f7db0d671ec2d96052f6486df733c8849dfc5f0c6e12bb7121"
    sha256 cellar: :any_skip_relocation, ventura:       "4f06ff7f74620fa31a2654c796f03cc944598937efd83bdc2abfcfedd14d6793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "830aed5ee06212c170f1c8036ba2ba7815585267f2118b162cfdd058eb830991"
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
