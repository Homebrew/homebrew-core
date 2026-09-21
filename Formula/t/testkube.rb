class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.13.2.tar.gz"
  sha256 "8b0989e1a52494438cd7b3571f3d1beb9b27529229c6ebf72ea099ca8c6d5865"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "faacb66c57d53db57dfe69d64e9008d9d363f737e8dfce69ce0e10d65f3a230a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8959fb2efb46fc913b62ee659e1857ced77346075aed7f73cfd8fc8eb624829f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98b4ecea41ac6f575f037c238bd6ce907ea8553de60ff84edd043b2bfb8e9e8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec27f9173e5ff2ac0e93917ad3e75e03306607eae3ff1ff95ef2aa57e2d9f202"
    sha256 cellar: :any,                 x86_64_linux:      "a87a15a5eb47a444cdabbefcee1b4f22d79a1c825728e9bcb94484d7f2a80f83"
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
