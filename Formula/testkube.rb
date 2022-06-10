class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.18.tar.gz"
  sha256 "284bc4165f5db4243f02da237a55eb70ff292f0c02f7195d82f01e4280b9b751"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e775d4136b32bfd6dfa9518c79be6c59a9524a067e1da2d637fd01856baa61aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e775d4136b32bfd6dfa9518c79be6c59a9524a067e1da2d637fd01856baa61aa"
    sha256 cellar: :any_skip_relocation, monterey:       "1a51b5cf3f99aa93587b009af4619bd45e318d50d40226f9890d7e0cfb9d234e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a51b5cf3f99aa93587b009af4619bd45e318d50d40226f9890d7e0cfb9d234e"
    sha256 cellar: :any_skip_relocation, catalina:       "1a51b5cf3f99aa93587b009af4619bd45e318d50d40226f9890d7e0cfb9d234e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52eccbe30f799034b47d720b4ffd2d6c946e7328d614e15b85842224db680c2a"
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
