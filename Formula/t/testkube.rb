class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.9.1.tar.gz"
  sha256 "f6525397b40ac95d37871f7fadc504988c45f07fc95bac8a0373aeeebc5eaf81"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2bab969f7e64f060c84baa38b2be341af8053ca1e4f592db178567a053de158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "191ba9401834026d7d9c3de34f857a73c1d9c511d36f33022734bbb9c35fcf56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da1d69dad53dce8b1cb3aadcd13e296a4306866785afb18eafaef0bc06164f7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5622239dd1acb0fc44675b69344ed258a6cda97f41878d161e395c048cef38a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1672f821fd4cde53d48ee7ac12167a1a500d9e9cf9932d878a72d13a0c14d0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e8cdff3df77e02165403b1e2f6eefccac7947b9d7c4201c441be4f1672b7605"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
