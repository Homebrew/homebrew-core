class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.10.0",
      revision: "05ba31337722314266d4e04f93609713f8152972"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cddbf166e2672d5049b7055d3bb712ad577d7bbcc892e3ce29e63455b85251e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "573623aed6869d2b91f6f1b5b73415baf49426c2444b72f5f1c1847c306f66f8"
    sha256                               monterey:       "48756c0f944aaed16ee20af077b6dbf1e3d572719570044b60df77de232f0156"
    sha256                               big_sur:        "e9e6b23bd6c292092fca7ceedd9fc007319928e11858ad4075603f7f2d5520ed"
    sha256                               catalina:       "99d6b8e7929052a14d2fa8d7b197611e2148676f4501bc49b3e5e791cef25548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3bad178a0eb84578428f206a6d494bea3db1237dd00c9caf8f762901ad6a7f5"
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
