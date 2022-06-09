class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "b3cb3d0c74455b9220abc79544d46ffbc5d401354bb2d4c9edfc9f808c0489cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f5e95d72e9d931b48696b16d1772634f9f8957d576b060abc6ac7781f41fe90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f5e95d72e9d931b48696b16d1772634f9f8957d576b060abc6ac7781f41fe90"
    sha256 cellar: :any_skip_relocation, monterey:       "c026f06c4549c1dd8f27eaa6a5f4071678e65c72f48a1d58c4044db459cd51d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c026f06c4549c1dd8f27eaa6a5f4071678e65c72f48a1d58c4044db459cd51d2"
    sha256 cellar: :any_skip_relocation, catalina:       "c026f06c4549c1dd8f27eaa6a5f4071678e65c72f48a1d58c4044db459cd51d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ebcacbb50cc2b93ed6018c370732b52f71a0b735c8bbf5e311f7a00af0433c7"
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
