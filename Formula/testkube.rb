class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.5.30.tar.gz"
  sha256 "160ae99150a648523da257f418afa48d4b443c519492803f717a801bedcb15f5"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b892dc8218ccedfcdba6ae7207a219c53bd75caa0a898e634bb64972e007ecc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b892dc8218ccedfcdba6ae7207a219c53bd75caa0a898e634bb64972e007ecc4"
    sha256 cellar: :any_skip_relocation, monterey:       "caa5bbc114ee21ecdbb36910f39282f3811213029705f49307ee9bb2ee47f293"
    sha256 cellar: :any_skip_relocation, big_sur:        "caa5bbc114ee21ecdbb36910f39282f3811213029705f49307ee9bb2ee47f293"
    sha256 cellar: :any_skip_relocation, catalina:       "caa5bbc114ee21ecdbb36910f39282f3811213029705f49307ee9bb2ee47f293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bce81953e028ab7dfef8a1610243ff9e5f61169e1598d2267becf57f856ac96"
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
