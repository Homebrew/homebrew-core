class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "8d3390658664a60b503c85ebf23d13c07b0defdbd29933f564aca03ba986e3b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8e21f277352acae67efb512075a34208e984bfef447fb02adc32aaa20bfb958"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "475290c42a13ec4e712c8e393e21c6472a227ded2d60f71f348ccbd67b4edaa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b42241b756e9b3e71a2cd0b3eb3eb2bb07704704ddec86b5b88d2681efd132e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dcb09a427b842313817776c6d8f1f0f02435ba80cf4949a1ca81bc4c19dcff8"
    sha256 cellar: :any_skip_relocation, ventura:        "3da9eb85ab125065e3eee2745a9462efd12913c43da53e51105f8217ce03d0bc"
    sha256 cellar: :any_skip_relocation, monterey:       "88f31206856f4001d0ccee2c50892976de098c394d0b9b14b74f6c6b68cfe973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2669a97b9f61fa1754641dd13d776cd5754faf3c04aa1118eb5e66f7ea978e"
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
