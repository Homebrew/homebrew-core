class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.5.25.tar.gz"
  sha256 "1eeadc33675d12972083187a059b4b919c0d3e12d4cb58f33d5515acc8343193"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b9466e6e61fd170229338a378f492dc7c7d0f391944547bd395d0442d4cd9a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b9466e6e61fd170229338a378f492dc7c7d0f391944547bd395d0442d4cd9a1"
    sha256 cellar: :any_skip_relocation, monterey:       "d91321e14744cbb0c4890a72cf92795226271abdb87e8868ef04f8cf77369a1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d91321e14744cbb0c4890a72cf92795226271abdb87e8868ef04f8cf77369a1d"
    sha256 cellar: :any_skip_relocation, catalina:       "d91321e14744cbb0c4890a72cf92795226271abdb87e8868ef04f8cf77369a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7436d1bc74dedce89cfce5295fa76e1fb76ad121b00017e2ecc2c39e2519cb7c"
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
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
