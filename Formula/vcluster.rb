class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.10.2",
      revision: "b0b4e22a71a4226f6e976d623a2f0cb9cfd36edd"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "634af7a5c87fec709dae35e4e4efac2edb8985fbb1db4c60b674fa2d84ec2c43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be0aa8fb61e31b6771094923d14eda2028d554f0b8ca9fb31f6c671c19b8808b"
    sha256                               monterey:       "df035d497f0575531e4dbbc5f9070d9fea7498b88c0287dca2237e0723867fea"
    sha256                               big_sur:        "9641b891d38bc6c05da1db13302029648ed1c8174003c70ad65fb7b4167f2120"
    sha256                               catalina:       "3dc9b92a9b6ad1508115225322177cac8978ce7341c7a28c61eede157cecfbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bae01782a1d193d3f0202e305441ce0c22289be53edc1a589a5fed05912f885"
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
