class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.14.tar.gz"
  sha256 "b794155ba08ec1f7c0feead1026879f1361c4f9fe44b9d8467d89fdc6231e907"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "566ee4fda96467228c2b40f839e77d7a19725c587d78e4198c6887f7ba85c1c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "566ee4fda96467228c2b40f839e77d7a19725c587d78e4198c6887f7ba85c1c3"
    sha256 cellar: :any_skip_relocation, monterey:       "43ddde64460eed1683d95c554987d0be980ba46a77c3dddc8eb24778aa45242b"
    sha256 cellar: :any_skip_relocation, big_sur:        "43ddde64460eed1683d95c554987d0be980ba46a77c3dddc8eb24778aa45242b"
    sha256 cellar: :any_skip_relocation, catalina:       "43ddde64460eed1683d95c554987d0be980ba46a77c3dddc8eb24778aa45242b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c57e3cd02a6983616969ade9c3d7aa06855a1345566df63188a1ce277f6b8cd0"
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
