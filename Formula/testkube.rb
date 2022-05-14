class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "b7e41ac362785adf3a0f26b604bead53ef9fdf330b57df2676a44594fda05ccc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89f6d509bb7bdfc26ebc4613a2ad870871ac4cb9db653c5d59620368378f1ec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89f6d509bb7bdfc26ebc4613a2ad870871ac4cb9db653c5d59620368378f1ec5"
    sha256 cellar: :any_skip_relocation, monterey:       "daed1b2e4f336f5ece2cb90afea41e32d1f657d25b59fdf7858c9635540dfd16"
    sha256 cellar: :any_skip_relocation, big_sur:        "daed1b2e4f336f5ece2cb90afea41e32d1f657d25b59fdf7858c9635540dfd16"
    sha256 cellar: :any_skip_relocation, catalina:       "daed1b2e4f336f5ece2cb90afea41e32d1f657d25b59fdf7858c9635540dfd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77331e9b26311fa47765632d509785e115f6b12c701cb3e4fea83ce88b5a473d"
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
