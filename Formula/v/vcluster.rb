class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster/archive/refs/tags/v0.37.6.tar.gz"
  sha256 "1b93bd26ad5f707f4b5b2429eb984e2c76ac52c753fdc686c37784dc44683a81"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec45cdbc866eadb4a96da285e5d797d0ddc39c89b86f2572922b3032ac8eea0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fde22122a56146e147551b4136a2b16b70f809e2a6dba5b4529a8d50fc89a9e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48e0b4f9e2aa4fe29d2ee5ce8258738610f5bb805c494ce32e054c15b3daf8df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "28ffd0804515fd108d7763c56a70bc5ca5e2e9b4db548d4cc81caa8a55d2a19b"
    sha256 cellar: :any,                 x86_64_linux:      "4b64bbe7566f4051b184c7174677ff92633574dd6c0c7a4b36b73435ef159c58"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  deny_network_access!

  def fetch
    # `go generate` downloads the disposable email domains blocklist
    system "go", "generate", "./..."
  end

  def install
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
