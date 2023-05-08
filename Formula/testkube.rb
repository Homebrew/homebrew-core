class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.11.15.tar.gz"
  sha256 "baecdb7856342934d6fda0a5205dd945cead85c67ef0a188c1bfc520af688ffe"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4df92d34875d952f55c87a634ebfb954725f9162fe4a20e661e99d52b412d47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4df92d34875d952f55c87a634ebfb954725f9162fe4a20e661e99d52b412d47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4df92d34875d952f55c87a634ebfb954725f9162fe4a20e661e99d52b412d47"
    sha256 cellar: :any_skip_relocation, ventura:        "a60505c483c7632f51543d310519322c817221002fb48f3eaedf81e21af81784"
    sha256 cellar: :any_skip_relocation, monterey:       "a60505c483c7632f51543d310519322c817221002fb48f3eaedf81e21af81784"
    sha256 cellar: :any_skip_relocation, big_sur:        "a60505c483c7632f51543d310519322c817221002fb48f3eaedf81e21af81784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f68ae930978f080c4ae358ee04e381ed003d496aacc74989d403bd2eecc34c5e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
