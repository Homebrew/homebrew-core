class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.25.0",
      revision: "f82ff4096581aeba8b00391479b8b44913d5a144"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "773563ba6343cc2ae2ecad81e2cfeea1ebf915244c361e1e603bdeecfd693b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ae4bed34b9c6621e5a928bcb717860ab8476bfe88e01443d48b6b0011656738"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc40b5364a1a2cc936ba2c62f54e8c5340ff65428fecc225bf542fc7d245e432"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d7b8ed890cfde35f7c0f51932d5e80334d69e2e7749ade00aeb087132ed853"
    sha256 cellar: :any_skip_relocation, ventura:       "27f1813139246fd851522c83b3a1ed42e46e3d81e1f7f2959748a6d55cad63b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "319eea31185760c2f3e0a62170ae44c89bca2c06ec618eb226588950eae4041e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "852a133f04f540d385f82ba050a6729f69eada3bb266a4c35f58d0fa944d4124"
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
