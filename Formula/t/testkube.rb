class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.14.7.tar.gz"
  sha256 "d653e7ebe24b22996e98ac6b27485cba53b62799ccbfa67a5659e9dfb4966519"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ea6e87ab8452438538aa189c22c6f5e0b19a0cc0712a5a842831843fa7374b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ec9df822d7f0e75eecfd4364a66aac14be77216f82bab3b97af111173dfa19b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81d4b530807c8335b6293ae8a1580f72890e6dc6d5875f1ba5e6fec40a414927"
    sha256 cellar: :any_skip_relocation, sonoma:         "99a8a4833d7d5082c1fa063538429981003cfd376bc0d7152761356326f38fb7"
    sha256 cellar: :any_skip_relocation, ventura:        "fe1d909757ec1a58c8ee7249e0528c48178618ebf71369371f6fb0f76b787ce3"
    sha256 cellar: :any_skip_relocation, monterey:       "cbcb026c53af39ff61e5f1a009ac9d8ecd864d93289aad1fbb3ef4f763cba5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce89f05bcfcdb47d349ec42fb4d85b9c89abd1b731fa36493c1a8c0bc20a9c2"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
