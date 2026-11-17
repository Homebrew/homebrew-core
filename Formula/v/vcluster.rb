class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster/archive/refs/tags/v0.37.7.tar.gz"
  sha256 "44310b83bbbc696a5b36404d404d7b85e8f691c4dc2a4fea9ed4d233f91652fb"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96f970ab8af87eadd08889b627b075f400896b41420752256999026d525f114b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36e7b0884e89c6de1f4062a49d3728dd08f8006565f65bade24b8441800dcca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82929e4f67667b0c6640fbfa265b45b7d0f0062f530543c71d9109ca58115ccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "009ebe34f0aaf549aaec40f910106c9987ded3f2c8ad8ff8ef4e0025199a6756"
    sha256 cellar: :any,                 x86_64_linux:      "5bbdc62750b2786f0af13b7d4837b8be6efc133753c4067238f69925637b1049"
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
