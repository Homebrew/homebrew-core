class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.10.2",
      revision: "b0b4e22a71a4226f6e976d623a2f0cb9cfd36edd"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8bbc8e0359ed20c3e5fc2d191ecb4f49febf055aafc26284cb1573a1c8b51db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f1c96398fdeed39a900fe57a2a961e9bc686d21f77af49520943d374e6fc55a"
    sha256                               monterey:       "c3fff563c1f854465db65abeec32123f1ce544c4d8042b23ec74446658195c48"
    sha256                               big_sur:        "8bbaed782c170adcee40e9793699ba98c399b189967de7c82331009d977e0f4e"
    sha256                               catalina:       "b9571e763aba247b8f597720b7d4dc5244a8f9ae41e5b8211e7c2816c31d13a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "def654c19777cf8c0dd2f0728ccb27dd0eb0719bf98f7704094431983e98e440"
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
