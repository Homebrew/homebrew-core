class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.18.tar.gz"
  sha256 "284bc4165f5db4243f02da237a55eb70ff292f0c02f7195d82f01e4280b9b751"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7e6daf2345c4abe4eb6978f8cf022f8e492384fdb140d45018395480938f779"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7e6daf2345c4abe4eb6978f8cf022f8e492384fdb140d45018395480938f779"
    sha256 cellar: :any_skip_relocation, monterey:       "2a024484a59d1d953ef18dfb2de7aa9ffd61480b9f772c3bf324a566bb684013"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a024484a59d1d953ef18dfb2de7aa9ffd61480b9f772c3bf324a566bb684013"
    sha256 cellar: :any_skip_relocation, catalina:       "2a024484a59d1d953ef18dfb2de7aa9ffd61480b9f772c3bf324a566bb684013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07dc8ec1005b2b34dfda97a796e70fe14aed602b3da8e431ee4571c9c57ca8d7"
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
