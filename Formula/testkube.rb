class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.16.tar.gz"
  sha256 "b5b371a6b314d52a4a0fe5a3161c42fc0457a19ef0027cc9d4008fb5a593f82e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d654b613dd8c5229838d32789e4d1c17fb4c8997ccd1eebdb6af5cc37806ca6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d654b613dd8c5229838d32789e4d1c17fb4c8997ccd1eebdb6af5cc37806ca6"
    sha256 cellar: :any_skip_relocation, monterey:       "8191b1369c7e4508ecb867c5d3b1f087ed0db283432bcdef2f3736fe73ae8643"
    sha256 cellar: :any_skip_relocation, big_sur:        "8191b1369c7e4508ecb867c5d3b1f087ed0db283432bcdef2f3736fe73ae8643"
    sha256 cellar: :any_skip_relocation, catalina:       "8191b1369c7e4508ecb867c5d3b1f087ed0db283432bcdef2f3736fe73ae8643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e35d4c3700cc46908bc8b4fc9aaaddacb478a38ebc86888de185a95b80a448b2"
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
