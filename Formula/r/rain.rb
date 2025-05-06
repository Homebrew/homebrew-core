class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "820724a0cde1066345982b81b42921af86906966d0e51151ed24a6e3c1f08740"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af2faec2d53bf7ad618047052040f01755d42feff97c7277b13f2618d2ddbc91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e92b3a6cc6c34bb7a3110090be658ca87af74d6c34c0d7a9f706b2196875a55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68f9a3eebbb7f1e978c7f9fec953c0c714d92a29f4fc479c945a66a17ac2081b"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e684ea5984aff5347de23c2a70922093bb75aadbe798bf09ea085f2c58b7ec"
    sha256 cellar: :any_skip_relocation, ventura:       "66d4bcfaf9dca2fe737fabd9b83b6d211ea79eed8b3fb3fcfb47c54cbbd6fb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef15f4820cb1fa32edddb2872d68a49a1de00d668294acde54110eeabef2a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bc081450e52b65ca0bbfd0fbbdec86755d6faf568e0926bfba406633824fffd"
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
