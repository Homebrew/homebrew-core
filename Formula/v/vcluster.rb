class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.26.0",
      revision: "d051e46411124a9d6db423c62cff338c17bf7866"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c3bcaa3eed75f4e66283082d2e5cb31f12ec259747e597dc91bca331b76fbfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d00fef58d52beed8e71babf383d5b07f9142ddfdb7234fae9e1d3f36dedb0058"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93668e983085b7b1f9b66005958e3d2e22b7fd410e371c55ccf4694870b5e46d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb5d91ec80ade1ddfea4180163870ae68b4a9b81c9c286ee4cb69fac71f60d8f"
    sha256 cellar: :any_skip_relocation, ventura:       "b039f564b3cc4fda56ee32b0c71c18c365a7a7e47544fba7f8ec30a80bfdf748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f050130dab40f146886e7dbb91ff90651e915af414f615eaeeaf10a7af515c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3388886200ffe1d4a3e41b4e0458695e93ee2805047213c790dad9bd0b6a868b"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
