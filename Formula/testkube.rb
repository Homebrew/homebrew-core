class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "a68fd2bf3d74bbd70cfd59b28c1d566bc32321be20f19444e7186c3b691fc042"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e0b27780a278630b4db76d96a9708bbbf93eae3dcfea9b1cadb6cb029e1426"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92e0b27780a278630b4db76d96a9708bbbf93eae3dcfea9b1cadb6cb029e1426"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb53e4793094bc2317415bcbb03675f836fcab3d72ec81603087c9d739a3de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceb53e4793094bc2317415bcbb03675f836fcab3d72ec81603087c9d739a3de9"
    sha256 cellar: :any_skip_relocation, catalina:       "ceb53e4793094bc2317415bcbb03675f836fcab3d72ec81603087c9d739a3de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85473bbe7ccf0b14b9abf877a59e91776ffba8c7bb1ea0f551408dd076e311d6"
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
