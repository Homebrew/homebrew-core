class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.10.1.tar.gz"
  sha256 "0d5ada8763f1fe1d500382c590241c9dfb046fb29ccb39d2560f33576ee00dd6"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9ea04bbb14acbd02f453e91b5fda7da6b4b9bc62e6af751494ec5b09d584994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "131d794954b79c371c4496c15e257cfae349288875f2fbecd9d42bf254d363fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "946a12fa0d95278c23b253e74fb7513d856c26e94bc3244a44155dd7e9621504"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51c185ed7079b34fbb922d32918584349c98f8bb98ff610c83fec0bf41b617d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d4abc2a147f4dfa35e923207b9cd44602597097af73a7ab2b4c39b0d7f76f1e"
    sha256 cellar: :any,                 x86_64_linux:  "04adc2aeedc06880ac7b680e771c69d740421ba32c391e3f17b6156055e04d24"
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
