class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "f87b31d12e38865d11a0d7fbc61dead9c9fae5175bb1b066337ce8bd9373e198"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ec9bad982c1dde76bc712cc738612efad2589f518b9cd84260dcf1a6bf23cb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc23042b203f3e0d756fd547123a9469611bebddbb0198c4347ecfe8ef768481"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04f82a04ec6aafdc410e69ab0384579f37e038343635fc99b818409e4da7c9d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f288cdf1a6f3e5d77efca9f2b7a4e4a17ab00ff2dea4b2d9e570f43fc152072"
    sha256 cellar: :any_skip_relocation, ventura:        "47e328a2cf98d96e66c5844bf1e5180a833f2545c8858868c47616944b171751"
    sha256 cellar: :any_skip_relocation, monterey:       "2d91d2a2a13e15e6eb44e6b9e573b22b717195b8a7c405b47837cbb6c50525c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13a24bb38ae5661464e78549bfd11d117da20dafcd3c3bdf78f8c9408db9d8fd"
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
