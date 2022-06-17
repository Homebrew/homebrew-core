class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.24.tar.gz"
  sha256 "88752b8fec8de13bd9d98ff6eb82d8cf59284cfacd5b95061505d46dca0a2642"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "052d4cc844f2d56081010b7c0c0fa9b2fc42582c3a1a1540933cdc36482cb354"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "052d4cc844f2d56081010b7c0c0fa9b2fc42582c3a1a1540933cdc36482cb354"
    sha256 cellar: :any_skip_relocation, monterey:       "955db6b9b0ad26e56f72b29d035496f378bd3b0913a61e9b2b799f9aa5fb9d2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "955db6b9b0ad26e56f72b29d035496f378bd3b0913a61e9b2b799f9aa5fb9d2a"
    sha256 cellar: :any_skip_relocation, catalina:       "955db6b9b0ad26e56f72b29d035496f378bd3b0913a61e9b2b799f9aa5fb9d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb5103af25504bd23272a7150f51b56aeadada38860d318f266abd506549aeeb"
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
