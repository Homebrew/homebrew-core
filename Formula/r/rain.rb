class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "0f563154c49a6bc09164551463daee01cdbd5e2a9ff7bbc54854276d1608128e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6b138b7d899ed35af97bd851d3fd21ccc9927cd469d9b0813c421b5a353650f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24b4435adafb9ad41249ccc289dc0d23d964c6633d372a1870d301ccf966f4d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1beb78818ac8b59c0ec2bcae5faefbc52b7a3ff098de363db5484ee025c09f62"
    sha256 cellar: :any_skip_relocation, sonoma:        "a54f5bf4495737fda0e11f2c69793e93b0c54daf2b4524808748d381d3e561a8"
    sha256 cellar: :any_skip_relocation, ventura:       "084198057c5b45c0d7c6a7b20f1b13360744a2a73bb2540a9e4cccbc4e8afbe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e2a270409632381f218c539cf9549a28205792926748080f6f8d100021b9955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77192099a7029e388e3a7270dfaf47b1166cb349b533eb3bc94a85894be1a4c2"
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
