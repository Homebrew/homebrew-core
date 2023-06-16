class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.2.tar.gz"
  sha256 "fead74b5e0663ca598887d44f0c681e9a2501eccc8f7f1d816041c1b2531deb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5ea7044405bc3c55bf1e8cd1f419de10d26515d8ddf199d4ac8bce4580c87c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5ea7044405bc3c55bf1e8cd1f419de10d26515d8ddf199d4ac8bce4580c87c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5ea7044405bc3c55bf1e8cd1f419de10d26515d8ddf199d4ac8bce4580c87c3"
    sha256 cellar: :any_skip_relocation, ventura:        "bf03c3cabcdd4148a1a06be8513cbc3051bb2e885bfc2688910686f0d001d343"
    sha256 cellar: :any_skip_relocation, monterey:       "bf03c3cabcdd4148a1a06be8513cbc3051bb2e885bfc2688910686f0d001d343"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf03c3cabcdd4148a1a06be8513cbc3051bb2e885bfc2688910686f0d001d343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6633a014dff0d8c930e9657f590d11ad67f782d893cd2b0b70500f19e55e4313"
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
