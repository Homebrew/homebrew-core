class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "3d38fa1967e3d4d5891cd1b35e58b9a6b8672ef780f85d3436e7c7cf40ca042c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35ac87ce7eb5a5473269577f0292b728235d97a94e01dd357de4e18a1c93be86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620bee2269b23836871d9539464af6a89e14e1b8960f92dcda815c753d04ce56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55f65e321ba52731516e716257fc65030421ea07a7bf8bbbe27621a8acdd2848"
    sha256 cellar: :any_skip_relocation, sonoma:        "05550960f35e558b450fadeb337904defd60d128d3a9349e79d35a933f20e81a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b82103f1b40f906e78807eab782445449c170ad713d49a5e13abd87317175ac"
    sha256 cellar: :any,                 x86_64_linux:  "91978308b50faee177efe172073e204b51e1c99c5bafbfb2af73a465d172d074"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
