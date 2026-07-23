class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "c8034401f02978f567b2e51fa2ae3af7adb5cd1328c56826bf45ac5a136e9514"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d58695064aa4b9b30582073e74637afceb59a63cfb5ffd0982d431f74ee9daf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d908e0c9bcb2e9e56a9b4686c4735e64bb352fbec6e915770a2533cadc644598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcc9fdd470c96f52404c1be440b66ed5b33d4ecc9a970bfc54922b5ed5889241"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e99c0b7d26ef5ae8a528f6eea3b9cf8b4906b257dd269f26b54e2c376d6ee9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75a6dcab83411f8a8ce763ba3491b0efccad4064ff895c6ccb7e0019bbc3a90a"
    sha256 cellar: :any,                 x86_64_linux:  "18c51512fd36753b17d35f37917992c85294fe3c2af6a470c3c837aa50c9f4a1"
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
