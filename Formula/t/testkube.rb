class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.36.tar.gz"
  sha256 "0acf06405b5110e0f31f5d0475cf7c8022328deb00ed07ef7fb4c3f91b947184"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "515cbe5c1d1791582dde2a39c476377dd4d5b5bba3dc6401fcfba7c252cfa95e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d81ef3c79b43c36c4c1cc4868e805b2defa89cc8461bdd4dcbb41f19b0a8ba2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2cf2ff8c605d841e102b0a46a329307e823e4f934add8fa6be19e1708015a7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "50fce5dc596951f2e8879ba653d5485398d30961324d67a9e6decb4465cc79b5"
    sha256 cellar: :any_skip_relocation, ventura:        "114d8af8e8c14d982113b2fb4c2715c2fbb16aab5efb56e6ed7a19832271d18f"
    sha256 cellar: :any_skip_relocation, monterey:       "dab318567498c30068578dd88f5a76744df3639a35091bbe66486d93a01664ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acac82a6bf5e29eb891efa69949f781430a6e0c55da2040d68399fbd054160c8"
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
