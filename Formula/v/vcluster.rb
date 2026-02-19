class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.32.0",
      revision: "b78126d731ef7d5d01ee9bd85897d0520d281f69"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dd269a447e9ce5816b76fd5296320dd4f2d146d118fda937bf181ddd9c9fd05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7812e71441926b8560484a7045ae9877d099712e0e6432f325c3cb14b592d053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6fc2a43d060282d71d10431e80cd0bab7f0efea7eac755dc322ea23616544d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e9bc5e33fcdfb0468c0102200b82a62f8ce4ea96699fb1bb6456a8be8d775f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbf2683ac6bbda3841bd0d7854626bdd94bb13a69bb2c1d3acbf4160efa88c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27e2c76de749452a0db3cd2a30ee3596676411a3d40bdab08614f5090de48036"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
