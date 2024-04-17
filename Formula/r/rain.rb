class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "59b3f60572ef108e5f651560c53be9d1ab509cbfcdc40a26cc1e1dd0cd3ce634"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78d2d7ba43c3e94c2d6975d13eec07676e1bf738876b69acd4c70fb0f5a9025a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02019e129c61ba507fae801d883caf36a0fba93097ffeba6e685fd3157002cc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "994e2a7465ad6965dfc641d6e58b3cd97af96c78d9a8b13c15b9c0cda858a17a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b98d1326a6f4ff30eeb84dd412f78e7f667d8595cb9fcbc333dea80a2a92800d"
    sha256 cellar: :any_skip_relocation, ventura:        "95ddfc58470c7600eaf7045024d1989a057a10462fd0cd62d0b9438ed0897ecc"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef88e3c55e701312e4649362c8fa38c8657718660c6505676a9920a4e2f70a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2914406942eebfca295fe2a6f69036ec7a345bcfeadcd82753cdae54b2bc6847"
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
