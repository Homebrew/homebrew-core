class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.15.3.tar.gz"
  sha256 "36273a709be4c3b70db8a90f599c0b1496d648aa9e4fe985ef590ec85ac86606"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "974931622b03c5348d23824a5c06f8b59fb2fdf10796c1c0297bb47a441e7e2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cad8233f6800cf7441ecdfe0bb9c137b5600c2217b86e733da3700cc395da80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a4fb630ca3569c57c3207dbad73091b183885c264e989957c241ce3072b7dfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1aa374f9a5b1a8fa561b1cca8796fac07f1dd93283167774b9ea0e72b500f209"
    sha256 cellar: :any,                 x86_64_linux:      "3ad58cae060acdef807330422b76957ca799c819f1434f4ded594d82eaa4c885"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.builtBy=#{tap.user}"

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
