class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "1bf031347ff0e3f51b16575639c6e6fc64fd2e7979a4f7678bfeb313fb5a2c7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75acc4f49b6ffd9cb2beb71374fa9afcdd531875d147fadd13c8f3dba42817d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811c510bb2bc86a8d8c7e729cab3b7da5ad4ff191b2aa8d7e8769c8c6cdea622"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a95c83c2664bc8046b77e43612858f9560c4289230622d124b083bf5aa5a72ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "76c9c20a14ec63368f60f940ea16daf36b6d52db1122f306eb135b53b9571ee1"
    sha256 cellar: :any_skip_relocation, ventura:       "9f02635eb635bb31584dc95e57a414769819ce614b38d860096b19d78feb54be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e907aeb5e64982f6f0435d75dc9cb531aa187a3c03a452ec36d75a778e73363e"
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
