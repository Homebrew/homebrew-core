class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "5e7921dac45a4d844668421f9ecde4be434d008b6c44cbfb872155a6643b0637"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4635944d9c3b44d88b5f8dd738cf2848de0dc4b0ff9ca23797ea0c69d2c7fdd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4635944d9c3b44d88b5f8dd738cf2848de0dc4b0ff9ca23797ea0c69d2c7fdd1"
    sha256 cellar: :any_skip_relocation, monterey:       "9c52fd0eac58fd165be142c45b1941726febd7f17c8e07898a8859455caf4a80"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c52fd0eac58fd165be142c45b1941726febd7f17c8e07898a8859455caf4a80"
    sha256 cellar: :any_skip_relocation, catalina:       "9c52fd0eac58fd165be142c45b1941726febd7f17c8e07898a8859455caf4a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61694f3d51a873ea456c07258acf6b8e18f78ddf7344bf76f79098f471e1fcf7"
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
