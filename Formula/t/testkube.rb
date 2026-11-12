class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.15.2.tar.gz"
  sha256 "ebfb7b594adc0fa2e3f4530156386bc557d81f000db569ea3c5306485758cb6d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "246d68de49ce5e08809cdad1640eb83103ab629291e7c06d29a836e3641fd412"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ec6792ead6c111c4ecdc2b5e85345a8d4ed56f18ac9aae8298316f5e7f84b27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07020514eb1c43ddcfacdaa61f222573a95112b96223dac788c1493607643cfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ed7bb16275c6dc5ecbd72c45191fb0c3ec9ccccc3f3aad9bc12c062c573ead7"
    sha256 cellar: :any,                 x86_64_linux:      "b8538d0212064fb7cdd7cdeed95c4047c9f24ffbd486739a5590673fa597bbd2"
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
