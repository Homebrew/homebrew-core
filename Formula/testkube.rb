class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.7.5.tar.gz"
  sha256 "32303b03194e02812d22c30b3cee3868cf77be9a791b2a6553362637670da71e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a33fbc67c26047ed74d888763a234f9ea39edcfa6760622e8db2c3cbe59bd51f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a33fbc67c26047ed74d888763a234f9ea39edcfa6760622e8db2c3cbe59bd51f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a33fbc67c26047ed74d888763a234f9ea39edcfa6760622e8db2c3cbe59bd51f"
    sha256 cellar: :any_skip_relocation, monterey:       "6085e7cc4396d9931a7474057d0e616829de90150e1976341fa4c2e64acce243"
    sha256 cellar: :any_skip_relocation, big_sur:        "6085e7cc4396d9931a7474057d0e616829de90150e1976341fa4c2e64acce243"
    sha256 cellar: :any_skip_relocation, catalina:       "6085e7cc4396d9931a7474057d0e616829de90150e1976341fa4c2e64acce243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038d0747f9ad7d058604456ac4c13c6971be7d2efb808b65845d96b2ddd6dc3e"
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
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
