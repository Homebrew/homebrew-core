class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.29.0",
      revision: "a9daf2b96ccf083b83942f12b896c832136bb6ef"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce3509e7ca752517cb364d3f0582d22e97d22e11a7c69db04250168f7cb88591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cc9a1dbd653570db767a3218d54101fbfabe285d18dcf002f25c7e97658710f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "814edfbd8055774ae92cd4c6f90e6673fb251aea9bf770fb7c8adaef8edb1b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "95dd9448bf9e8af893d110ad822c7bbadf1356486fc47fdf717e8ae628469a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db6d7352783ad52f47ac79f1f10810a00f716a2bf11d1a1cb8c5eb798f7414cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0b4a80092fa96d14a675bd322794372db06e78c72bd632105b1e37ca1233d2b"
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
