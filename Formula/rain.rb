class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.1.tar.gz"
  sha256 "5faf25a87a6fc0fde19edcf2fe6f26c81990da91d13fbf3858b1eb33711b0ebd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "237a1279d22b5ec71a2486ee5e2d22593c4bdee13799f90fce2e0f997f8699d8" => :big_sur
    sha256 "58a41b1f55e10383f88a6fad0b3e56f09790300dca99f708c4d4938cd71122f4" => :catalina
    sha256 "ca22007322e318dc109b541bd54dd2994d3c1f1a50ac4211e1d6503781478ee7" => :mojave
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
