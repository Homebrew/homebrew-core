class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.20.tar.gz"
  sha256 "ead34a2ef4df1d7f6c0f7d293168c6c4feedb922df81dca6de141573cfc1421e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "674b72af4a3d936914752149c0dca417c0f68c8ced828ddfcfc26115d5e4ffe0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "674b72af4a3d936914752149c0dca417c0f68c8ced828ddfcfc26115d5e4ffe0"
    sha256 cellar: :any_skip_relocation, monterey:       "f0dff9f9b11c72b97f01efded7038190cf864ddba6b413f0dae8551f391d5652"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0dff9f9b11c72b97f01efded7038190cf864ddba6b413f0dae8551f391d5652"
    sha256 cellar: :any_skip_relocation, catalina:       "f0dff9f9b11c72b97f01efded7038190cf864ddba6b413f0dae8551f391d5652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2114c935c7b89c6d2fa957e0dc6a9d8f0be71d839d53b2f315967e21c918195"
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
