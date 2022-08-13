class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.11.1",
      revision: "893710319456ddfd33a463ed0d590d77b7fa1b95"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e501902ef9729daa8d614ebc0b4fb38e0f8a613903f6a3c066effd4a0505397"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6460a90edf9c61465dbe265fc63c09164de134695a619a6aefc155a2a77c78e"
    sha256                               monterey:       "41f9489f424e45dccb3939295a185d8b7add04bf6ee01fcd0a6ed4cc86708295"
    sha256                               big_sur:        "a5ce9c50697eb070e3d76cfbe3965cb4f95e676b42a33d0ab301cd0547e08b2b"
    sha256                               catalina:       "e785cf7389160d80e5a7b347711111ec2b8da22136969f162395518e3039e426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db89f675364400f10e140afc6fd436b50f777e29c15747aa057a983e497b0779"
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
