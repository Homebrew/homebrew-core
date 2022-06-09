class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.9.1",
      revision: "c2382e17e6de5ad72c9b88e81a083d9e3823df5d"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ed79b35fcd75bed2b2188d6b80c530af1ae1b0c33e95b801328014be37b751c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08606bcdfeee835fdba322d7f374c59775f1a7ca5750c24c85c3379afac885b3"
    sha256                               monterey:       "2b486fb251f3aea07a434a709b50420a5dc94a7630afbb52a35b09c632f3f1d9"
    sha256                               big_sur:        "80ed81158fa43235c3340ac49ec87950f8087c3a0525d8158169136b065c1431"
    sha256                               catalina:       "e4f81225434b4005cfc2b9a0fa630953eefc8eea908daf47ba2985e3a5627629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b9f6d5f3026806f7c016bb8fad3fd125bed0b42797008f26d6be3ff3bde25f1"
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
