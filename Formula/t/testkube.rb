class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.5.7.tar.gz"
  sha256 "170eea0e1384a608024a2b74fd195084b085d37959fc1c47a03fcefe785202f6"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb681ba4128ab519dca083ebede8f05d80060a7d5ed439c61d41d30179856c67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12dd42f22bcb150d8a5a43c2332c3c48a68f45cf32782f8e299fa9ceec957c5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e190a5edee93e2d98e8d72a735e95ae545e8fd872fdf4db8bdc556017a35e0fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8babf9acc553ae993dc64f76da49e1140a49387962312090fa4f405888e692a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db408459bdc05bb6413d663f2c037f7d037dff626a038496d30d3f70cb30c910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb8535ea52ba564411ac0e4aaace5e960ae68b9ca60daf117fd1a4502fb6e502"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
