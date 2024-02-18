class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.28.tar.gz"
  sha256 "f97ecf066c0ea17eaee4326e9bca4a3f1567db6110388824ba87d963136eb36b"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73b41c5f553cc8b5d5e9cb61ca0ada5bcb080cb580433308123e0835166f0607"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b13f20571555a06dc8b361c22176e2cbf5a127d4265dc81de79c0dc22e3848b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6931ed06318def11b40766a6cca1f7c7a0c0343455035ed6a54d3482923227da"
    sha256 cellar: :any_skip_relocation, sonoma:         "8798b2c6297cd7cbfa253dada7d3aa10bfcb877d81594134d0d214bb9b079549"
    sha256 cellar: :any_skip_relocation, ventura:        "e6291a9f936c0ea73f148e5816b355c02ab1d7d1ee72ac15cb3d37cdfefde01e"
    sha256 cellar: :any_skip_relocation, monterey:       "47a6bdf19ee8be77cbe6044e9aab99c999428ef8c3d09bbf76eea6a5ca8b78f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e250e2b936eebc05ae93f773909d867fa7502a3fbbdcddee2d5752170d4592f"
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
