class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.15.tar.gz"
  sha256 "3d949d4f68aeebb707ab777fef6d8db37bad601d010e161cf1bcf34de996d986"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2570444ae5f43bb44ac105f09dd91c33ef5cfb4efca7b0f4389bd6de980eb43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2570444ae5f43bb44ac105f09dd91c33ef5cfb4efca7b0f4389bd6de980eb43"
    sha256 cellar: :any_skip_relocation, monterey:       "cb0e063c0700572b117c0a2c505db5a65a080f19383599e66d8fbb1b3759e142"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb0e063c0700572b117c0a2c505db5a65a080f19383599e66d8fbb1b3759e142"
    sha256 cellar: :any_skip_relocation, catalina:       "cb0e063c0700572b117c0a2c505db5a65a080f19383599e66d8fbb1b3759e142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d635678202d14b1d4c801a21b13917aa4591ca4d7c11b03f794a52b655cef85f"
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
