class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.3.3.tar.gz"
  sha256 "230db11449b34043dc9e10a009134bd5dca240dc20a5d12710b98606f62559a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fe8155395e59dc30f5650c84935a371b6c4d19ebd6370d66f674b27ab147ac3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a74c0dbb131873eb391114fbd97ca9cb57421f7d5175a47e16ed13eaf5237b1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef947cd281d29ae17560c91492632e79804f25322b00dececefcfaa33f47eb30"
    sha256 cellar: :any_skip_relocation, ventura:        "c4d473d054e2ad57ed516acea26b71aac143d3c53240081a60a2447662e7df82"
    sha256 cellar: :any_skip_relocation, monterey:       "fa2b84383641a4d95500ba185cdca932e50c89c41465119347337e7c07a9328c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6d3bb608dac5a48f092de2798f2214b6d40352ebf522c356c53ac609cbf5c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee65c2f8d67c2a030ab8b03013dc5bbbc913fcfbdb0127bbc9018d9e50da778"
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
