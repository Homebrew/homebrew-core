class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.32.tar.gz"
  sha256 "b4437ea2512b56c8fe5542e7af743ffc3f5c9a948a12f6c2568a9df5c0848ddd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2361fee9bda0dd5ce6467def9d6dc42acaa6b74d92146172cbe573091e1ff8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2361fee9bda0dd5ce6467def9d6dc42acaa6b74d92146172cbe573091e1ff8e"
    sha256 cellar: :any_skip_relocation, monterey:       "7f734aa843c7cc0b4b20844264a73f5a9e43859707cd6650c96d2f1bb88bbabf"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f734aa843c7cc0b4b20844264a73f5a9e43859707cd6650c96d2f1bb88bbabf"
    sha256 cellar: :any_skip_relocation, catalina:       "7f734aa843c7cc0b4b20844264a73f5a9e43859707cd6650c96d2f1bb88bbabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe65414d08cf1752cc6b1dbb6a4c746c1c26f38c768d32fa4a578583ff63bbe"
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
