class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.0.tar.gz"
  sha256 "a255a1e76569a2cbe3f9a876a27f49d56d87e7569d737517917334c4277d2c0a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6e569595881788423e14251b7955044c9e81e1ddd31b740ddf49795ff0d57be" => :big_sur
    sha256 "86072c7652b2818d1459430cf1c8afc71e6210ff2f6deac60895b31075c20504" => :catalina
    sha256 "fd4831e3dae19f8c65c918681c60985d0ff4cfe439cf437f49fb4211afd5a951" => :mojave
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
