class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.4.tar.gz"
  sha256 "e9cb12dce01fd38c2a642fb5850db7ccc3c77d22e135449430279ac061c7a61e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fee2b2a22322f7f0ae90b0f25f58ab1cc078c752abd1a3b2a63294a4713b48f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fee2b2a22322f7f0ae90b0f25f58ab1cc078c752abd1a3b2a63294a4713b48f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fee2b2a22322f7f0ae90b0f25f58ab1cc078c752abd1a3b2a63294a4713b48f9"
    sha256 cellar: :any_skip_relocation, ventura:        "b7ce7737e253c3acdbb06029bce33f8cdfb8a993689ab1561949a49b5ad90b57"
    sha256 cellar: :any_skip_relocation, monterey:       "b7ce7737e253c3acdbb06029bce33f8cdfb8a993689ab1561949a49b5ad90b57"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7ce7737e253c3acdbb06029bce33f8cdfb8a993689ab1561949a49b5ad90b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b7b5d8de789ec41af86bc5c05fc659ae2d4765ce09e2e838da20f977154f25"
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
