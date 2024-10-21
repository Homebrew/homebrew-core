class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.44.tar.gz"
  sha256 "107e0d872533d71c5afaf22a1d714733fb480207f3e65882d54d410a5368cacd"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5933cf044d57ca1ab4f28a06984c04710ce7fff628c5f82457dac2eb356bd18a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5933cf044d57ca1ab4f28a06984c04710ce7fff628c5f82457dac2eb356bd18a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5933cf044d57ca1ab4f28a06984c04710ce7fff628c5f82457dac2eb356bd18a"
    sha256 cellar: :any_skip_relocation, sonoma:        "53c51eb15ad392d08a7e62d3f886295cbb5e6c97cfb32e70aa82c7d6dfee80d9"
    sha256 cellar: :any_skip_relocation, ventura:       "53c51eb15ad392d08a7e62d3f886295cbb5e6c97cfb32e70aa82c7d6dfee80d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "348199485c9da5bc483c3f74aa9f33d02d403964c1dd36bc7ca7ed29b844e267"
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
