class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "a49d6409eec1549c9990c5352b1fcf0f3276df7f1f10cf7686493c8be262840f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80cd0585efc6fff97ca4ca3c53d68fad49e18dbe5a50d005560920fd213d0335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d44a7cff01869e054cd413e350f324e1d953486ca66404a5a0402f860d42e9cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cbcd4ed0757dc5258b6f86625cc19c0e32abb064b3caea797df868dd84d8c8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0475b07e8dc5790aa2e28ccfe68fbf1b6f53375c2d0fb3842fbcff680998d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88db63dbe8596d9878b94b867fab53ada875bd97258f2bfbb7b87313ce363ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985ef13a7da3045a419eecdb1fa9252414d75222017c336c1bba98bd1de5a598"
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
