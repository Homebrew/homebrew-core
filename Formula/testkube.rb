class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "f2859f2bf4ad60b61269c86098da52e71bd8efee260a2150f34f7cebf7172cf4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "713f03b21c43d04e87000b9d796ca25109e36426fb6900cf6ee0857dae80c6c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "713f03b21c43d04e87000b9d796ca25109e36426fb6900cf6ee0857dae80c6c2"
    sha256 cellar: :any_skip_relocation, monterey:       "91b550b3e795c9074e300585d518f5940a2e2074a5a084ae276c332842a214eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "91b550b3e795c9074e300585d518f5940a2e2074a5a084ae276c332842a214eb"
    sha256 cellar: :any_skip_relocation, catalina:       "91b550b3e795c9074e300585d518f5940a2e2074a5a084ae276c332842a214eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8dc6379cb18009e8a0d701d6799f7dc229484d9bd43a817986928cf5ae6a97"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
