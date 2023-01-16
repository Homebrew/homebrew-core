class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.8.25.tar.gz"
  sha256 "26fce230d7ae6cd61b2643b1e91978b54aebc0bbd42ac52f00fe3493b1a8fbaf"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ddb6f3bd5f6e02a838a5ad4b7617273595ade9e0fc81f76662ee28d042bc0c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ddb6f3bd5f6e02a838a5ad4b7617273595ade9e0fc81f76662ee28d042bc0c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ddb6f3bd5f6e02a838a5ad4b7617273595ade9e0fc81f76662ee28d042bc0c3"
    sha256 cellar: :any_skip_relocation, ventura:        "c2017bb3117becce325ddf90e8e8b3bd198b108816d06d37ba1f907ceddbceea"
    sha256 cellar: :any_skip_relocation, monterey:       "c2017bb3117becce325ddf90e8e8b3bd198b108816d06d37ba1f907ceddbceea"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2017bb3117becce325ddf90e8e8b3bd198b108816d06d37ba1f907ceddbceea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "976318446756f58c45709362a5d11c810ca9d9161b71917b82a5d65561176f75"
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
