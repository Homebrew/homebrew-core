class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.39.tar.gz"
  sha256 "a3e8dc6807e112f265932a405be88030bd92e7a283f54c5255615082de18c543"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cac2e31c2d23b104360717c1f9815f45451c45fb603ad4228ec257ef99516f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "218cf8a54135fa56891320a7ba080affff3ff5d8a5d2bd8ab5695ece85634169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb241c8920187f6865b33e797032ac77337aca7f23842f1e88a8edf06c6b41ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c38db709ac246a72d16bea0054e767b22fdf6e40fe9d7fb91c0a334d239eda6"
    sha256 cellar: :any_skip_relocation, ventura:        "ceaaddbdfe743b741ec120ca3e2ce4b5e01d2c4ccae9a1f130b8ade45b18ebfb"
    sha256 cellar: :any_skip_relocation, monterey:       "8b67e7da858250b722074d0c3c49779717d6a7d64b6fe73c769029a671fb525f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fc1169aa982236f52b32aa1674be80c99af9eff8a6a9470ba681701557ab523"
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

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags:),
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
