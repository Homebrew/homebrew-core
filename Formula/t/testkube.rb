class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.14.2.tar.gz"
  sha256 "91d519d6934d68949ff98c50ec3adf6839691388756ab5825edef5ff992b79f5"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9247476d269abfa2c86335099d874705f3b1b532db062ccd279d442c7748e534"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ea268fb75a2f964414a87e38eb8e660d2f346ab4c585d1685b7d62202921f03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a67548ba7b9244f2c0f6d2a1639e785f5b66abe919fe12be9b065b081693aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "697f3b0a7d12f87c3b77efbb7f59d6a6f6550567ac50f4ed31611a4534caa4b4"
    sha256 cellar: :any,                 x86_64_linux:      "9622097afb80e12d9ea27043892e382ddcb8eb7325c7c150c05639e6cbaa95f8"
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
