class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.37.tar.gz"
  sha256 "b40dd90c108d09243090b06a5dc3d22b8f17e52671c1a21114e4ee633b00959d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab6959c4ff25e68f7a9ce00e4b77c9561b4b0539e9b48c3761d370e9c6957e70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab6959c4ff25e68f7a9ce00e4b77c9561b4b0539e9b48c3761d370e9c6957e70"
    sha256 cellar: :any_skip_relocation, monterey:       "fc7a9a382e6fe73d4af83cdb0652babc6a179f0a1553b1c576174f778da2e857"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc7a9a382e6fe73d4af83cdb0652babc6a179f0a1553b1c576174f778da2e857"
    sha256 cellar: :any_skip_relocation, catalina:       "fc7a9a382e6fe73d4af83cdb0652babc6a179f0a1553b1c576174f778da2e857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd50e4bae797e5f9ea4994e74b1574e47b4cbeee720aa471552f84d48c50679"
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
