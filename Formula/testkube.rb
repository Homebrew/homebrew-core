class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.16.tar.gz"
  sha256 "b5b371a6b314d52a4a0fe5a3161c42fc0457a19ef0027cc9d4008fb5a593f82e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52a17809cddd21c98b6db6054e2b029f1415e28f1ff900f269ba0b76feafae8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52a17809cddd21c98b6db6054e2b029f1415e28f1ff900f269ba0b76feafae8e"
    sha256 cellar: :any_skip_relocation, monterey:       "340b4842db30be91409f1507068113b9f2f363a4aec227220d11509c0a038e93"
    sha256 cellar: :any_skip_relocation, big_sur:        "340b4842db30be91409f1507068113b9f2f363a4aec227220d11509c0a038e93"
    sha256 cellar: :any_skip_relocation, catalina:       "340b4842db30be91409f1507068113b9f2f363a4aec227220d11509c0a038e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b92d82076637ce55fc7f5803db01d78309d74104fbe45fcb6e489e3a89965e47"
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
