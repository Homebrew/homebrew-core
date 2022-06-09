class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.9.1",
      revision: "c2382e17e6de5ad72c9b88e81a083d9e3823df5d"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a348977b92f6970d97535c260169295c701ee352054625a9a91255c441519835"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5af083239e01556d553b6b2cc216bfd69949d5c2e0bb596bbe57c1b2c70a773d"
    sha256                               monterey:       "3145d1e80ace077a1a78a6b317d1c6158000df2b5aa163770f3bf73dcb4c9fab"
    sha256                               big_sur:        "d852913addf19a0b7bcf2a9f07c7284b5df7cf25a64165a7fe1736b8e39648c2"
    sha256                               catalina:       "ad4be01538bac0b937c7df1fa32d4cc17d98ce3ecfb5fc5983034ab1a5549670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cf0c0f7607b876f90647280bcfbf9b630ce4124230fb4e9725e65fd690b81b9"
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
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: ldflags), "./cmd/vclusterctl/main.go"
    (zsh_completion/"_vcluster").write Utils.safe_popen_read(bin/"vcluster", "completion", "zsh")
    (bash_completion/"vcluster").write Utils.safe_popen_read(bin/"vcluster", "completion", "bash")
  end

  test do
    help_output = "vcluster root command"
    assert_match help_output, shell_output("#{bin}/vcluster --help")

    create_output = "there is an error loading your current kube config "\
                    "(invalid configuration: no configuration has been provided, "\
                    "try setting KUBERNETES_MASTER environment variable), "\
                    "please make sure you have access to a kubernetes cluster and the command "\
                    "`kubectl get namespaces` is working"
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace", 1)
  end
end
