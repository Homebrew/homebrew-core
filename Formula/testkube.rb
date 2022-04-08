class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "065ad36d885fb9bae7469c4e2c6dc421beaaaa043a828513db5284bbfc815159"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f760d0b33ff38925b74875df75c52951c43c922a14671c4956f17dfa3cb2093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f760d0b33ff38925b74875df75c52951c43c922a14671c4956f17dfa3cb2093"
    sha256 cellar: :any_skip_relocation, monterey:       "8eb0cd64ae6b83bf3fb376194f4ddb4d305428c6e8f348352348cc4d9e41c63b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8eb0cd64ae6b83bf3fb376194f4ddb4d305428c6e8f348352348cc4d9e41c63b"
    sha256 cellar: :any_skip_relocation, catalina:       "8eb0cd64ae6b83bf3fb376194f4ddb4d305428c6e8f348352348cc4d9e41c63b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "835887715673ab309678016866dda82903dd8e5a37886c36819464f9d91500a9"
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
