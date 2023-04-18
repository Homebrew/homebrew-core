class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.11.0.tar.gz"
  sha256 "f587692cb15ef0ea66883d12ef497ea94c24719291f15e16106b75478dd1d290"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47e7b183e4bf6ca23e421e78cf591ca32bcb7c605f0ab2c6b84647c8154a7016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6659446fed7dfa5a3c65fe93b1c13680a0c4eb8ec4356a67eb9365ecb2417a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6659446fed7dfa5a3c65fe93b1c13680a0c4eb8ec4356a67eb9365ecb2417a7"
    sha256 cellar: :any_skip_relocation, ventura:        "b61864205445abf43f2f2630c6e16ba95afb6cf14add1b34d8e4d4f6c9087891"
    sha256 cellar: :any_skip_relocation, monterey:       "b61864205445abf43f2f2630c6e16ba95afb6cf14add1b34d8e4d4f6c9087891"
    sha256 cellar: :any_skip_relocation, big_sur:        "b61864205445abf43f2f2630c6e16ba95afb6cf14add1b34d8e4d4f6c9087891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76febf1fb292a5eae32b982069e7beb69817300b2f3ae11375833ff5810e9ea"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
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
