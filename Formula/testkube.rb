class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "a0679086568557a376de80abc0af5e79dc95a60d71060696c7f76d4c4da77bf9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cf8ee6797a36ea29ee309a8a00458d351c97e5ac7f30df8bbc7e65dbda79dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a793fa9e22bd346fb2804928cf9c40c5f806680cf3416061ab04dc4f20efe083"
    sha256 cellar: :any_skip_relocation, monterey:       "f14fdc71864b8989f5f46c38207efba2e0b27f07a89c804fc011bb18a7a802a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f70f73334eba667c24cbf547a96c830da827eb3cd8816c4015cac87f462b4a9"
    sha256 cellar: :any_skip_relocation, catalina:       "6f900c354ae3027d27d8418be72e3e521cb74b53f74bf8af061e663bd3783451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f026507804d63e7c651bd1822997d7664661227e92844a1d33c09e407c81804f"
  end

  depends_on "go" => :build

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
