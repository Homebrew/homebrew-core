class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "b3cb3d0c74455b9220abc79544d46ffbc5d401354bb2d4c9edfc9f808c0489cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b9d4d882fe015eb8bfec58127739a1ff3cee28045d3b9b1d6d28b0a4c865c28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b9d4d882fe015eb8bfec58127739a1ff3cee28045d3b9b1d6d28b0a4c865c28"
    sha256 cellar: :any_skip_relocation, monterey:       "5cb8105d208128360c507f652d142dc63640ef7e14b1d5d97c55ba7d99d4850f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cb8105d208128360c507f652d142dc63640ef7e14b1d5d97c55ba7d99d4850f"
    sha256 cellar: :any_skip_relocation, catalina:       "5cb8105d208128360c507f652d142dc63640ef7e14b1d5d97c55ba7d99d4850f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58ac22b1239f2975f133198f45addc795005eef524de89261d69206d7adc848a"
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
