class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "cf8d2519691e7d3c05be796ef6404c3d711c544a803180842a2563cb998ceb75"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b3c1dfb3c4cd6d6528ffdf474fd2c1d832aadc9e037be0e8ee65bf021e9fb4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b3c1dfb3c4cd6d6528ffdf474fd2c1d832aadc9e037be0e8ee65bf021e9fb4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b3c1dfb3c4cd6d6528ffdf474fd2c1d832aadc9e037be0e8ee65bf021e9fb4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "01e0c5489fdea3cf4b51f71564d61564868f89bc46a257354d15829f1b7f8601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e9540598fed819983a2196a3d0f7648a073d961162466aa410380a63f8a35b"
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
