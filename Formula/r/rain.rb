class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "f56190d874985e0bcea79cc1ca233846173164d000f0c4f1d0051f2e26fee20b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "217dc323f8bc7e9b9aa6c25bcca31c5330a40f4c32a1ee39c0fe80c833d45b56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4dda9063b22b3a3ab22ab02b0f8a2b09e6d83d554bd884a63ddf90521e80020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3056de7b49e1676eb6119d81292f727459a5582c4dfebcaa65d8477faa9c717"
    sha256 cellar: :any_skip_relocation, sonoma:        "8614c6ffc8fda0f6bc503b52b1e6f92b2539e6a884603bc20c16dff724ea3a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38326eef10def213333f7d7cda09ba8da0067cd44e8f2fa1d0b077098aa54b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa8e98cc7e27b32e63ec2f4263b07f642ceffe585577451ca29cf1c3bf794a5"
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
