class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.11.5.tar.gz"
  sha256 "91953bab901b29ab22550937e40e15b95ede58d742f40fd6220b49512147b551"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cf91cd974655a3bbffb3dd859b981f9d4403a82c639bcecc8a35dd59dfccab9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84b18262b5a40830c7516c3be522b3b8226db8071af492cc1e15f7136258b157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cf91cd974655a3bbffb3dd859b981f9d4403a82c639bcecc8a35dd59dfccab9"
    sha256 cellar: :any_skip_relocation, ventura:        "6224bce823b4caa2e7a215d1088920433600de39b41c57cb839ee943bc59d57d"
    sha256 cellar: :any_skip_relocation, monterey:       "c34ae5feec54d3c22df341d2e5122424d6d477104a9024713fd0a8ea436e31fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "6224bce823b4caa2e7a215d1088920433600de39b41c57cb839ee943bc59d57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90cc7d22951cb34d8962b5d78f12ae5fbd647d6d6c8eb433a6fb01cd5d800aa1"
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
