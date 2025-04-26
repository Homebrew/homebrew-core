class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.147.tar.gz"
  sha256 "b67e35a77ba50ecdfa5179babf3bb2ffb2e732eac4a4f662ff7241d9cb5bb3b0"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72371bdd68b5a03f44ed15bca1822c295139c3427a2a41ab59e00024aa0dbc3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72371bdd68b5a03f44ed15bca1822c295139c3427a2a41ab59e00024aa0dbc3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72371bdd68b5a03f44ed15bca1822c295139c3427a2a41ab59e00024aa0dbc3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "02b1b3020fc6eaa55b68047f83ca8c27850e1e2e075ab776d3fe8a436047feef"
    sha256 cellar: :any_skip_relocation, ventura:       "02b1b3020fc6eaa55b68047f83ca8c27850e1e2e075ab776d3fe8a436047feef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ebe5d3637270d22cd190d58a050e811555cbb3c43d9e97e7220046d7236096e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
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
