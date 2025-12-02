class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.30.2",
      revision: "1f27e1acfcd7715ed7e16b0c205cb1410d826376"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebe5f32e61d7f6069c6f2c94eb00da1e16209d2d069c6cdec48715277dbcfe76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afd8ac566a54877a832b3cb365d012819d44971860ff51299b2c80a85c69bbd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bf317a28b4350049e7332bbf0e08e858da5fde2495aa5ab8b617de1bb35d7a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea5f3f2bea3d2e85c1c4af18d5cbfa254e9c9184fb87eddf17ba5aada80fe044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419b17183232ca253fc84de17658128845a95ceee03277139b1cbab529ccaa55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b575430556e7613216a13c91a6f04e664945b03419b81d318cc329acaa4c556d"
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
