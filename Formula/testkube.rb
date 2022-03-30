class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "5a326a7d069873b776c690fdb22f342764e6bd3be6eff9ea28d482a5e20d9e13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fb08f45cd175fdb4368b0306f4d307b526068d029e3c951fa0855e45d4d6b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fb08f45cd175fdb4368b0306f4d307b526068d029e3c951fa0855e45d4d6b55"
    sha256 cellar: :any_skip_relocation, monterey:       "088be1b60db51de62668e0bb7f0775725943a8aec4932581be7a520400ab8675"
    sha256 cellar: :any_skip_relocation, big_sur:        "088be1b60db51de62668e0bb7f0775725943a8aec4932581be7a520400ab8675"
    sha256 cellar: :any_skip_relocation, catalina:       "088be1b60db51de62668e0bb7f0775725943a8aec4932581be7a520400ab8675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "515c56164b5e32aa49bf5b70245383729f2afadc4c76089cdc73ac81e0b67137"
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
