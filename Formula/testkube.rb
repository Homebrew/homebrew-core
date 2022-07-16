class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.3.12.tar.gz"
  sha256 "c18e28892122a6d4727c560db6b59b7507baa631ed17c749bf7c84343849d347"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67064a00b74833eff09888bbde626f1032b64d7a21680c85787980f4b2c36e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67064a00b74833eff09888bbde626f1032b64d7a21680c85787980f4b2c36e9c"
    sha256 cellar: :any_skip_relocation, monterey:       "6a950cfef29d95f70d265ee68b1e58ab7d7bf3701471ac33c71b5598ff0f04b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a950cfef29d95f70d265ee68b1e58ab7d7bf3701471ac33c71b5598ff0f04b0"
    sha256 cellar: :any_skip_relocation, catalina:       "6a950cfef29d95f70d265ee68b1e58ab7d7bf3701471ac33c71b5598ff0f04b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eb79983c8235f0ccae238ea5915665ab19ea2de3ffa4410a40c0e5d7328c3d7"
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
