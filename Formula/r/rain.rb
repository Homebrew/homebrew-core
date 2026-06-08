class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.4.tar.gz"
  sha256 "1387dd8e17160a51e8c99fc6654107bcb39dc94a137338c13e4ade30a344d3ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a99d3acaca2c207112e76910fb6cc54190cac115ba35ac5e7ae6d1a083499fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc71aeefb4f73507004dc0eed7408a5ca01f2c9c39ebb9e357265a48cd93d61c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "424f86556c186e4c2f3cb540953c74c9addba4f93046478081d28e39c719c7f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7bd351b138986c6e4ee4216093132e3dcaca1918fecb8b17e5e9117cda740d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b8f5ab33822bb03b9b0a365bfd2c395fee56b703187f30036085613bb9a0142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11f6e2e191cbb1142d26a1aca6366c85860b29026edf8dc077013d48604e0f6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/rain"

    bash_completion.install "docs/bash_completion.sh" => "rain"
    zsh_completion.install "docs/zsh_completion.sh" => "_rain"
  end

  def caveats
    <<~EOS
      Deploying CloudFormation stacks with rain requires the AWS CLI to be installed.
      All other functionality works without the AWS CLI.
    EOS
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML
    assert_equal "test.yaml: formatted OK", shell_output("#{bin}/rain fmt -v test.yaml").strip
  end
end
