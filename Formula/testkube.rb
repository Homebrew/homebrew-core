class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.6.25.tar.gz"
  sha256 "1bc3133abf46c93a99ac58137e9734f6d48a810d91e4b97f8034747763a4cef2"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1494e7f75bf904a5c540cebcee592f1d7214558e43f1f803e6079080de954344"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1494e7f75bf904a5c540cebcee592f1d7214558e43f1f803e6079080de954344"
    sha256 cellar: :any_skip_relocation, monterey:       "ac8c4920fe43a44fbbee63672ef33a8fcc151389902841d19c109fe7e8ad364c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac8c4920fe43a44fbbee63672ef33a8fcc151389902841d19c109fe7e8ad364c"
    sha256 cellar: :any_skip_relocation, catalina:       "ac8c4920fe43a44fbbee63672ef33a8fcc151389902841d19c109fe7e8ad364c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a1d69903824f528ca2be17fd9e6333385e68b737d6f895891e3b85602794d13"
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
