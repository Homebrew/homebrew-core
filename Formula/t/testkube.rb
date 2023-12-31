class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.20.tar.gz"
  sha256 "fa7ce2507881aecdbe782ec413fb752fb5bcc5a412e8cbc2acc9a3c2e7921ab4"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0037496e340b1d749a6eee38a51767c3fd1b1a48ed974e4e64e5d378e0ebff56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29a774941d80f96d78f666148de5d39f53f2540018c0e0457a2d9249c0c82fbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e151ff6bf3a1a3866e95bede487d6d8819fbdb58d7d4ef939d38ce313b1fecd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "46c587e63ec5c5ecdc35639eaaeaa88a975f73c57f7580f0b4ced8e77f835143"
    sha256 cellar: :any_skip_relocation, ventura:        "629cd526f540101ceff9ea696029f26ae7d5e696b5f5e0650a1aee05d7f5153c"
    sha256 cellar: :any_skip_relocation, monterey:       "2667a52cc544a7f99b06d213a76108600b558d5606f5b273883d3aeba2081516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8998213a2fe96c5da5765325bb220a5ecec92050b19f3485b4dd5fe1aaaeaec4"
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
