class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster/archive/refs/tags/v0.37.4.tar.gz"
  sha256 "8fc11028b123ed928f9c6401d6d016d867d9a55e2848422783b7e842300f97c8"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3cc97b462eeb858dc08fc85029dc0d4ce3c69ba52138fd03c4e562c33159d82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20c84e02e7d22e8949fd2c2025be0975fae2c12636317a75b8d284c83eba1440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76b2fd5f9db8d73f43ce9080bd87e4355197c66fa0334dd0cb55a137f058dd40"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8576dac995ac9fd5665106ad94de8caee34eb4d7664bde5c84f3f00dac627686"
    sha256 cellar: :any,                 x86_64_linux:      "1aebd9e85f64eb629213e771682374567366801ccdf936e03899ebbffe7fc9a5"
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
