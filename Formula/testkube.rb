class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.10.tar.gz"
  sha256 "5c917fe990a504ec2f70342f3743c7f5d3e59f70a03eee2abaa9068b376ba6a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051d9cfbc5a05911c22341ec52252660577d60e56de117701434dfa0dc4a1ef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "051d9cfbc5a05911c22341ec52252660577d60e56de117701434dfa0dc4a1ef1"
    sha256 cellar: :any_skip_relocation, monterey:       "8cea9238d65ff36e35ef5130011e457a18e30030f161f86a82de079e623b2c07"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cea9238d65ff36e35ef5130011e457a18e30030f161f86a82de079e623b2c07"
    sha256 cellar: :any_skip_relocation, catalina:       "8cea9238d65ff36e35ef5130011e457a18e30030f161f86a82de079e623b2c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b767f847b44a42484873fc44ce3f26b711bb0f24dfa3a5e3edfbb10262be4984"
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
