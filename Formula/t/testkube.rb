class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "773a58dc4fcac269d9938fa7df6e0e3ddd11552f2308a25deb33e92228cf4e2a"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04b8003e4c7e45a6576188a1fd4b699e65d2d064a62696afd27a6b62d2ef825a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1b98ddaa1889a565d4eba7a53082027276b8b3b387d324b0add4cf45fc2104f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf64ab42a9d6850050092c013bba3bcb335671dfb1623e113b2dee0fc54e2fe4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b4e5af248c2d4e5587f1d2c4c42ea8bb139fb374fae8d77ba14f0e5cc988314"
    sha256 cellar: :any_skip_relocation, ventura:        "ec1a7a7b763a16cd345c6595a9406718f2dcebd2b310f70a0db0ca4ad1c54e50"
    sha256 cellar: :any_skip_relocation, monterey:       "9ec4bd5c70e78e1ecadb30e5b83c624ee65286cbcae1810610ba49eb4403825f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64f5297b95474f8b003143dd16faf0f8751e7daab900416b2645204af2f5fcda"
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
