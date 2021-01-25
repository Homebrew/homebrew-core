class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.1.tar.gz"
  sha256 "5faf25a87a6fc0fde19edcf2fe6f26c81990da91d13fbf3858b1eb33711b0ebd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "55f486e76dc98d428be0c746d8dff11e337911fb97236a09a41b9e25d6dfc0b7" => :big_sur
    sha256 "12c9a02a0092ba5b911ca47a13073c3ac736c369aa3351352370f7a5308a79b5" => :arm64_big_sur
    sha256 "f3ef06e12e92b1e196bdd77d9b1de8c9568494883ba1c6a24d3201151576920c" => :catalina
    sha256 "f9ecd6ae894e0f4d8ce92c017fd17c7d6bc1346e9142c34b81bf4ac3b04d54fc" => :mojave
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
