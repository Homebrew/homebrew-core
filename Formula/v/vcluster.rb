class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.30.1",
      revision: "cd0c687776132b88f532669ec8020e76be3a3441"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e1edb61e3c25f57cd938ff03290c2650e6931d2472ce8a636c48e7638107121"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b64f673eccb74b57ad676d902c1e9203892cb6be38d14de50090928b3eb00caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7d3574d5cd57b4c0bc9eabde247a2460ea5719b2fdeb8cf73e84db886c98df7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4d9d34c98ba02ab6c898999cf8c14788ed36776d9b79d09c799dcd7027a5f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae47dc2581f843c4e25412076798df92edd1487c1c9551fa7ba1a27598db616a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edd3825c070138b76e0c5581752b7c84bf98c8f1df630d9603a5a6a7e53d7290"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
