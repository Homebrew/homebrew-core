class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "47ff89511181b9e79abc1a9491d551417b66a515f32c09bd5b278aeba3a03937"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8c65446c7c3b27f180f6f26a633b52903eb49e1b4385058423c56925ed40ce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca6448b03bb697e891df0f94b602ca385fc11ebc406e8db709969f0df983756c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "555214c89928da8cf8507844f475cd172290e71944b2ee91175fa83f61fd5b36"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b9d09d84b6ba424adeb0f2240ac813a9d5b09d821da67cbcb3f513fb52872af"
    sha256 cellar: :any_skip_relocation, ventura:        "b89afb27bdfe6fc07161af4974eb11b6024bd9ee2ec2bc91bfadf25ad9a17874"
    sha256 cellar: :any_skip_relocation, monterey:       "6a19d928cae80a565e4397d2d1e24d084588acb61536e21367b6a4108d20ac5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f8274297f213e8753362dbed017ba3f8916999854b4620d960f6c9a0bbab658"
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
