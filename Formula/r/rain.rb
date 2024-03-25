class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "6e7a87913f963afc349c8ee9da5ffa6732856df6eef63c930db72c3de1812f7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d74b94b36efc3cf672deb1268dbf28c585d0a03ef22c7362521ee2ba1866f581"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7002926a22b0d32fd3fdbab0090c18f44d166199dab33af8946f69860a5a5d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "124626aba6016d9064ccdf54a37b402551cc24b7190563c4754d529236090391"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa988d49d2f5f01ed36250c25f2cab34a72ae9cf2147ae8ee4c61c80097c4f65"
    sha256 cellar: :any_skip_relocation, ventura:        "05c209ccaaf6e3bcefccfeace40215606600f878b757bdddfae210274c473b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "8b91dcd39009e187f55d57d10152fbba0611ea5664488f537662b8c83134946d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e030c7751d5163c3ad62c577e6d17d512763e625a89a5e7df52c0f83475520"
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
