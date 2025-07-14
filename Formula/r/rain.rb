class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "37fb974ee0eb36ceb80f38f13141883f3779a81c79562d0ad15afcd74753485e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4c31e085d0107c25909db36c2c4df1bbfc21bcb3260d7478dc1324ac0995ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15d05e072d423d6df23fadc7237e8607f17e749884ec656640571366f25dfdd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eedd4c33fdf1bffc2f1b3c8106a157174bfe7eb5bb3d5a8b32d837cededfaa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9953614985f14bf21b2b3b4ab88d179cda5da27e5e36a2d85a9a0115eb7c27f"
    sha256 cellar: :any_skip_relocation, ventura:       "3cf376704499c3459de1d7e4f47713fe3006c0907f1bed480e1f0045dd6b2f06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32eebc8816cb5e77606f4ea200b634850bfd59c74e910feb91678b4f957f30b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9cd406c6cb1bfe9e46c928b7db5a478af2c510883145028d004d938ed4c1cd8"
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
