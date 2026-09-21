class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "34407287bb0fdfe6cb832c25a86d9bdbe3ed3a0f5208631ffbf30707087fc4be"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e86b960ca14db0892da2b8161b6f22e49b9061afba7d56b823e88c054de5767e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa86e10f9f9a843c6852af1f023eff91d8dec8a64d919d3c1204b7270bd603fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6cc76ae2505e30baa66732ab345118f5f1c8a42aab8b68156801d84e690cb91c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f49c9efece208968d59e53cbb6093573a085c2ae4266aafa267eb7ea7bdcaa93"
    sha256 cellar: :any,                 x86_64_linux:      "23016301b81fd8998da4d3627e8e5d068c562d8f71b5ad70e0b2ccb6d97f7f1d"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
