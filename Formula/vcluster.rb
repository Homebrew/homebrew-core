class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.8.0",
      revision: "1a4f4ee2d696dba7829373fab889234559069067"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c27bd7a4c291f49c80d1e1aed409d5d0def7661006f3dfeec65f43e82c6ee7a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46e19e4c7cb6f7f2d202372e8940b5c5c5634aafde2d7329daea81b4d44c7ec8"
    sha256                               monterey:       "c240fe5ede657520c3399e857c584ea1dbbce3fab3bd172a487b86a53a33c1e5"
    sha256                               big_sur:        "ac23160dd80a21a808c25ea429b8267ccbb31b5ff5e1d36cbc8086992a3ef52b"
    sha256                               catalina:       "014767796058fff1733ddef7c376078f5e9a7bafe498dd30afa263025f5fa40d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4bf886db30e223f4314abbb4f2192da961fb817cde8d008af3addb66309be39"
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
