class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.3.2.tar.gz"
  sha256 "db9c0c72d2e6a5e0d0114b9c6e5a33f32ad4aad9e80c9dadacab2b7e9c2de35f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "418902fcf070f3c0935eaa1e19f1a0a88dd528235ad187457e13302ac9f5b470"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1217aea668a9e8109d7812aaccf35567ba921cb86e868979babd9dc562a27ff0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00e2261f9b2e13c6f9d5ff31d8667d14e4afd02d3a78a4ec78ec2aa9e2ef8d4c"
    sha256 cellar: :any_skip_relocation, ventura:        "1b6bf35ddd81d2d732a0bfa93ed24e62921e0db5b76f9833fc139354c1def8f8"
    sha256 cellar: :any_skip_relocation, monterey:       "245dbc19f8c583d6a1a39a131ed651a12ea9d91aaa80312f934821ebecd68762"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd16898b69de7efccea794c500305e3b5ce5948fb12fc04d2a4cfbe9c57234da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5daca8070c1f256edb61ffc520b6aeaa9afe8004260016308437c1ded28f7d0"
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
