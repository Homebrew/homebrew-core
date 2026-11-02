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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45131ff41e4a093a5a0735f3e4987c8569706a144305d301533350ef3d530293"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "553699e96902cac569b063bb808be8826e6ece8a24b112e09d395df896a34cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54308995ddcb9bf4859b0838a1cd7d14898ecf57d9c645b42539f92794e63e0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "76efa83a415c6bd433b53c77c1b32fea7b576e4e3416569b8801df1e4143e4ce"
    sha256 cellar: :any,                 x86_64_linux:      "34f1c9747e57dc210fabce1b0fa59e87f6da80040dfc76ec0b7bc1eacc906236"
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
