class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.5.40.tar.gz"
  sha256 "099194b7ef18a9cdb1f690e8fff699ec657f28de08efc7ea81629e330adc73c3"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6630b101ff4e66767899978aacceb8ae0422c1c98e05494f5daf606ccb8c9d40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6630b101ff4e66767899978aacceb8ae0422c1c98e05494f5daf606ccb8c9d40"
    sha256 cellar: :any_skip_relocation, monterey:       "b109014d8045e86193e88315d6c4147ead56f78fbea65881edcb8b1ec8141032"
    sha256 cellar: :any_skip_relocation, big_sur:        "b109014d8045e86193e88315d6c4147ead56f78fbea65881edcb8b1ec8141032"
    sha256 cellar: :any_skip_relocation, catalina:       "b109014d8045e86193e88315d6c4147ead56f78fbea65881edcb8b1ec8141032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc7ae41f24c44c21249278eb137cd3d565f46655f3605d535062a9e457aec47"
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
