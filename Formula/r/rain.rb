class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "ef6dc71698ad7d8caf1cc9d0d6a64aaf8bbc21d2449c0af804a2146c23950f91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de6e4df2486bb5ad4dad33165994a188c66bf80c0b84c0ad066d10eef810d3db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34992df333c5edf54ba63b4bfbf78ae928e06f52408df65030a8bd1d4e634856"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cecbed85f7160c365cec70d1a3d7aedd5f693d1c8949f4a00764b1c5150b839"
    sha256 cellar: :any_skip_relocation, sonoma:         "30cea6acc508968b5dc0f7be55efbefc9b49cae4a127d9efdcf03555e83893c1"
    sha256 cellar: :any_skip_relocation, ventura:        "702085ed0abc95ed8ad0eb544ad788b6e347d9c640bbda8c982a376a8625c7c2"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3d4fbf9f94f99dea8b9e048431162a4c19efdaf18f32a9820da966a99bc242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8a3a50cf4a46e06125c916f86f168584865dff6460f42313574145e5ff31c9e"
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
