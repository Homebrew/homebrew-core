class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.11.0",
      revision: "bd4f6197eb6de06e9225e9214e302de3acb02945"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b436a2afdbe3f3457f79ed5e6f43805d9659984d1c0e5d582f217feb8bd05ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a781708b686101af6bace2015099e4c4978a532d977eff97d9099b9fc833b55f"
    sha256                               monterey:       "07996b41c6f195cbbff68ce80ec38154e7318515090b8afb6126953ae095cba8"
    sha256                               big_sur:        "92457f60ebaa8764f8fa806d349c25e318f6d737f7c9e6c9a0ceeb8a71a78aac"
    sha256                               catalina:       "822375d1b53e31696f5178708f4d066661fb7d8fed2e37303bc52b47cfe33567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd420d92774e99dc4584fe1ece436970fc16b97ce655868fa9f7c62ef838bd2a"
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

    create_output = "there is an error loading your current kube config " \
                    "(invalid configuration: no configuration has been provided, " \
                    "try setting KUBERNETES_MASTER environment variable), " \
                    "please make sure you have access to a kubernetes cluster and the command " \
                    "`kubectl get namespaces` is working"
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace", 1)
  end
end
