class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.154.tar.gz"
  sha256 "50dfbf06c3691c4609211441bda2f470d3c4b999b85beb547c706e66ba8012d4"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5748e58aaccb22f4588b591b12ca3a0425027e73bd268d8f58213d3c8712669a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5748e58aaccb22f4588b591b12ca3a0425027e73bd268d8f58213d3c8712669a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5748e58aaccb22f4588b591b12ca3a0425027e73bd268d8f58213d3c8712669a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f782ed35750cbd7609cfe094d1a5d476088df4292f22e52fcbc9ad458763607a"
    sha256 cellar: :any_skip_relocation, ventura:       "f782ed35750cbd7609cfe094d1a5d476088df4292f22e52fcbc9ad458763607a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ac9f1e999f24b2b789b0ea03dcbc2a1fac82c851f9449ced971fad4e3280a36"
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
