class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.6.0.tar.gz"
  sha256 "c29365570082ee15f598c1a0af46541e42e77651f13e0ed5adabb67f8cb80ff7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33e4e1272031492ee6866d2ea1138009365966cb516b646078ef9fa650cc771e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9275a2b60fff4f495893c44cbacc4728f035f77c853831f2d79366d41818f911"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca27e27bc7585610e95ab504bc8a9b12b6ea54d6002e9e52ed7ccee5d294cc9a"
    sha256 cellar: :any_skip_relocation, ventura:        "c072330d4198cc22d1871d895b0d0509ab400e3fd24ab88cb241853fc590cfd8"
    sha256 cellar: :any_skip_relocation, monterey:       "112f70c5c7a7959f990ca5533223fd407532c74e25d8a88b771dca6511fb6539"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2bc2629f5933ecfa217c58f412b9a46199baca7de1547d83a27662792e19557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d0eca8a59df5ca29464b2b336b4d23b0cd93d568eb2b35f2a5262c60f15d54"
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
