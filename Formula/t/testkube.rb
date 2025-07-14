class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.162.tar.gz"
  sha256 "58e72489d14fd0e0e4d31bda6e7a524831b5f79ef30a5ece0f3ce154b5d5ff42"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f824cad7c858ddded7ba6cddbe229e942366e9251a9f2b0a9aa428cc18f6f15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f824cad7c858ddded7ba6cddbe229e942366e9251a9f2b0a9aa428cc18f6f15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f824cad7c858ddded7ba6cddbe229e942366e9251a9f2b0a9aa428cc18f6f15"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e65048677083104530dd5f3fde8f4d0c69e587d69cc457a39d366b32078b102"
    sha256 cellar: :any_skip_relocation, ventura:       "3e65048677083104530dd5f3fde8f4d0c69e587d69cc457a39d366b32078b102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516da6fc70fd753c46b4bc4889795bcbb8d5c079c31d7a3a18233f78a2ffe012"
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
