class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "67bc01d96245bdab4a4045554674e549896de45e2a4744cac9ccb02850fedb35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3876e6f717442bb70dc5cf52575c1b700188dd351db4a28cfd170d870f364a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9baae90e3cd9608265ff9e0a26245b4591c61c502a66cad436c91f05c24a7787"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab88b6195d91a55cc26fc0023642c5df164d136b20fe285f77fba515ef4f451a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a596e2a22118857abb54b18a047d42a16f6a4c87689dd5741c740b7608b93c3d"
    sha256 cellar: :any_skip_relocation, ventura:        "b23b73076349f064fc7e42d422dbe124cc668ca7257b412ea29d3b82a3a07afe"
    sha256 cellar: :any_skip_relocation, monterey:       "3a82392159997e49657efde3578ce7c150f7ccd917fb93be453d516b5d96a8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcf377e7c51314276be817a2d6140a429f67eb752ff7c14c683fd741aea482b4"
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
