class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.20.1",
      revision: "58005894621ecb17166c38f5f8f913678e9408cc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8303e37c33d6f2a0c18a855aab2c7a6332e6e877a1d5821ab98807b1b1067307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46703d558aedb39054db8395ec485b002a6bd58cbfec6595a7d4c2f7726cac3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97cc829980917268ba4331ac7124289cf7f01dc73ecedaa51422292c5f1db8dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "944550bde690bd69f99f21d5c68ada8f2e9c12488cb887d807051d84b9336f2e"
    sha256 cellar: :any_skip_relocation, ventura:       "c68044329a0435a35bf826f2357cb998be082e791f5f80f277b924e1ce332ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6e6d5a41c88428050440a9c730bc712eb2174abf81ed6e246f323aea083d46a"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl/main.go"
    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    help_output = "vcluster root command"
    assert_match help_output, shell_output("#{bin}/vcluster --help")

    create_output = "there is an error loading your current kube config " \
                    "(invalid configuration: no configuration has been provided, " \
                    "try setting KUBERNETES_MASTER environment variable), " \
                    "please make sure you have access to a kubernetes cluster and the command " \
                    "`kubectl get namespaces` is working"
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
  end
end
