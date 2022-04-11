class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "fe80beb4543650c867700695b0c6ae397cdcd1a849668031e69ba890891160fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc71fa4bd18f08fc6628f119464666e395fe425664d6f26438f0a57cc3cbdd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bc71fa4bd18f08fc6628f119464666e395fe425664d6f26438f0a57cc3cbdd9"
    sha256 cellar: :any_skip_relocation, monterey:       "535ee924b56bd3c03573a242a27fcea2796b721bfcacfae9cd1adf34f01eb630"
    sha256 cellar: :any_skip_relocation, big_sur:        "535ee924b56bd3c03573a242a27fcea2796b721bfcacfae9cd1adf34f01eb630"
    sha256 cellar: :any_skip_relocation, catalina:       "535ee924b56bd3c03573a242a27fcea2796b721bfcacfae9cd1adf34f01eb630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed756b04a53fbfafac9ac9f378b708d017ae04d177e5fa40e2cf36560e4c4a0"
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
