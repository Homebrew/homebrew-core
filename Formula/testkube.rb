class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.6.15.tar.gz"
  sha256 "a25fc9bcd2a9f22e3baaf7ed41ff4a1741995648c668420211371914a9d22f53"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5408f1196499aa11b23c2d8dd3f7aec6371cd8a8780522c1baeb267fbc00665"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5408f1196499aa11b23c2d8dd3f7aec6371cd8a8780522c1baeb267fbc00665"
    sha256 cellar: :any_skip_relocation, monterey:       "bb8943b89bb5272bfe270eb4c0920c3e0c227165562443e072090e456a39e936"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb8943b89bb5272bfe270eb4c0920c3e0c227165562443e072090e456a39e936"
    sha256 cellar: :any_skip_relocation, catalina:       "bb8943b89bb5272bfe270eb4c0920c3e0c227165562443e072090e456a39e936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "058526538a0eb5d19c1bac6764a2913d868d9dd63b6547927be9731d27cc261e"
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
