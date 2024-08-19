class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "dccb0ca38f914ef450c422cd27423f1df2c2abf25fc3e58ab388d08efdebe762"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e48bbe07c79d040df685a28fe0c7fd7e847dcf3b8af99b91c9c785bbf6352d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57301fa966e5fe429cf8dca1d79b154a4eea4c2345d8df38b76a9f55e99f962c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6830fea3d49815f06e9fec594350a391be290f0b5e940f6f68771ab25b84fe7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0f7e735c67046f9798d4198a5f8c626e06800540f6d3c3406773a855491586b"
    sha256 cellar: :any_skip_relocation, ventura:        "483bff4d88e6c475450d6be3e9ff204c23142ea1a1d101d838afa6b7245ae68d"
    sha256 cellar: :any_skip_relocation, monterey:       "5afc1b70613ce1c12b1d070cb3405ee31401378bb2dd624b52b5db58d52f7106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb4da4f56bb7b00f97c951dd03e1f593169719e73f6abd5e2342b3df6259a6c5"
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
