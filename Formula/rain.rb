class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.3.3.tar.gz"
  sha256 "230db11449b34043dc9e10a009134bd5dca240dc20a5d12710b98606f62559a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85a7cf0bf08ac971ad1eba6f74c3a1e6d9dee0ce2cb761e49bdcd486398f1a6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85a7cf0bf08ac971ad1eba6f74c3a1e6d9dee0ce2cb761e49bdcd486398f1a6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85a7cf0bf08ac971ad1eba6f74c3a1e6d9dee0ce2cb761e49bdcd486398f1a6d"
    sha256 cellar: :any_skip_relocation, ventura:        "42082494a482213b0faf80c821df98c1209dccdb6345941a2b0c82c9783af767"
    sha256 cellar: :any_skip_relocation, monterey:       "42082494a482213b0faf80c821df98c1209dccdb6345941a2b0c82c9783af767"
    sha256 cellar: :any_skip_relocation, big_sur:        "42082494a482213b0faf80c821df98c1209dccdb6345941a2b0c82c9783af767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04eea94f576a747cd92ff823c6e5d7d66782f635c7fa476ea3048b9ef5d07c7f"
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
