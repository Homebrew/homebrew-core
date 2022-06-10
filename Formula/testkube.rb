class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.17.tar.gz"
  sha256 "2fdfc1eb5727aa484ba5bcf8df33b559b2610bda933e264fc02cf78249072f54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61f20a30542c921c29a83cccb7ed2badc57746f7ddad049336c68f9e6e713d4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61f20a30542c921c29a83cccb7ed2badc57746f7ddad049336c68f9e6e713d4a"
    sha256 cellar: :any_skip_relocation, monterey:       "76f9b43a399c45124f2e47e4ffd2ad627cb88b0d5724313457e9f2920f4887f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "76f9b43a399c45124f2e47e4ffd2ad627cb88b0d5724313457e9f2920f4887f9"
    sha256 cellar: :any_skip_relocation, catalina:       "76f9b43a399c45124f2e47e4ffd2ad627cb88b0d5724313457e9f2920f4887f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a6cd16010dccf45eec54a59acc91d69e6aee6daa487f1ee4da1f1a6b07506f"
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
