class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.15.7",
      revision: "3b917f958f6c69b665e4eb27a62dd88fa639a29d"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "971a22b42b7a56c565afd47ee01b999c27faef6886e62066ccfed61c099a33da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e05d7296b460d7e3a8b2c9fefd662524f29f431a6d3793bbb00deb0b12c71e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5684d2f82765345e98be1835f78e26691cb0362ca530e606664bbf3a0463e52d"
    sha256 cellar: :any_skip_relocation, ventura:        "ada4396301840b37701fa3a048f7afbe0d4bd7a25776e64b09a625ac711d4ec4"
    sha256 cellar: :any_skip_relocation, monterey:       "2e606aba6484575aad5a1afdf276c24580a846d7f9b8fad528243d620524ec30"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e398edb0e8190827f3abeb5f80acb6f08eb7020f8d6eda994676179e47fb28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd2c6196d14093a55a9a636b7503e425f15c631823a083052c84f1312acff8f"
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
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: ldflags), "./cmd/vclusterctl/main.go"
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
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace", 1)
  end
end
