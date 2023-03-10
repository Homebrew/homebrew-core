class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.9.30.tar.gz"
  sha256 "b3478a2df1124a550e3e87a743cbe41653bade9e1de0eaad1991a43b0535c0df"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b763c302ba19e0d3535b91e5a6c75b933f963374a1812567bf6ae7cc13028af5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec4877ac3a709417d1871271b1b78a363f163c72285819ef9e95f6407c6ce12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b763c302ba19e0d3535b91e5a6c75b933f963374a1812567bf6ae7cc13028af5"
    sha256 cellar: :any_skip_relocation, ventura:        "255b2c38729b3f9a47274b21b109f40a28829688c656343478e790cb1afa5f0e"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd4dc2e86b0a914d08b869b63ca75a8c1085cecb2f208b6e2be4294710d537c"
    sha256 cellar: :any_skip_relocation, big_sur:        "255b2c38729b3f9a47274b21b109f40a28829688c656343478e790cb1afa5f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4021bd21cb4dd873ef1912c2e5c11dae2ba45168e2943ff4b81c4284314bbe"
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
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
