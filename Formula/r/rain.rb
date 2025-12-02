class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "d0930fa6ba78b3941348b6949ee999c3de3ae87f328b7be3a8e40286cf2858bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7471f99845b436c3fe8c811a5628cb3da4d5d6a68edd07c05faacd6fa04ed547"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9edd915695fdf25132e398379cffa0b0fb7f5b399cf7372033ad5554db0d7c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b8c49718cc36de4af62fb89830924388587fb0549f5783c0273943214026c21"
    sha256 cellar: :any_skip_relocation, sonoma:        "c21302e84ece93326c99e82b43bd2319655c4c9f8688ffc02b6cfb9951c1e70b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17302200cc8c889cc6eb5a85f3783144faf1760483f33a0068b5b519234cdcf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e5236083644fc2dd69af8dd5f5554efff5b2b44b40d97599f1bd9e26e338eb"
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
