class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.14.tar.gz"
  sha256 "af76f0e419295141dc7b8137bec62794470db54085dadda266ce78b888762159"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35b03699e7fffd9ef1800570743f48ce87bc568a3a014d5d94bd62b13bc753c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35b03699e7fffd9ef1800570743f48ce87bc568a3a014d5d94bd62b13bc753c8"
    sha256 cellar: :any_skip_relocation, monterey:       "e86c9a02602111b2c3324df1cd23ea8c5ac89c6a388eb0c24e30753757b38c27"
    sha256 cellar: :any_skip_relocation, big_sur:        "e86c9a02602111b2c3324df1cd23ea8c5ac89c6a388eb0c24e30753757b38c27"
    sha256 cellar: :any_skip_relocation, catalina:       "e86c9a02602111b2c3324df1cd23ea8c5ac89c6a388eb0c24e30753757b38c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee4925f890cb4ef61c0b704707b640537fe265b90015cf4b45bc3b52afc61a99"
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
