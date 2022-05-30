class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "7cec0d48df8a4b92ae5569e82504472764785aaaffd96fcee94e7eb7c6300553"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d94d5141b5b4f939282e81fa10955ac2e35e5aefca025f3955c677e1d84a372"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d94d5141b5b4f939282e81fa10955ac2e35e5aefca025f3955c677e1d84a372"
    sha256 cellar: :any_skip_relocation, monterey:       "1ec2598bb31634e76c449cca76e8d59b5f18bb2c507921c72af1491a2e98aba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ec2598bb31634e76c449cca76e8d59b5f18bb2c507921c72af1491a2e98aba3"
    sha256 cellar: :any_skip_relocation, catalina:       "1ec2598bb31634e76c449cca76e8d59b5f18bb2c507921c72af1491a2e98aba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec62a8fe77293e4054705e7323dfbb777a76c74bc81f74e03e4db6a8532ba82"
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
