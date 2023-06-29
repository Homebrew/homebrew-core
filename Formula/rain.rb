class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.3.tar.gz"
  sha256 "b77b985ee964f794030b3c1ed0b16f65680fffba1e24054e02cffb0e1fb91602"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d9f09ac24c53934759529673cde73ef6cb6b265b111173ca5994133bad66489"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d9f09ac24c53934759529673cde73ef6cb6b265b111173ca5994133bad66489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d9f09ac24c53934759529673cde73ef6cb6b265b111173ca5994133bad66489"
    sha256 cellar: :any_skip_relocation, ventura:        "a88018ace0e31a51ecf66a524f2ea8669cb0907ed5b01b63ef40f7e3828bae03"
    sha256 cellar: :any_skip_relocation, monterey:       "a88018ace0e31a51ecf66a524f2ea8669cb0907ed5b01b63ef40f7e3828bae03"
    sha256 cellar: :any_skip_relocation, big_sur:        "a88018ace0e31a51ecf66a524f2ea8669cb0907ed5b01b63ef40f7e3828bae03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3243ed93b297f9be54349fa0d8aff057b52f5032e9769920ac662a55cba5a2a6"
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
