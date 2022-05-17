class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.8.1",
      revision: "a95fb14799145efa165b8acdd9ca436dfd6da15d"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c96b36a44d6a2d3f7a153f5a20b407e3b055640eb847b1512087db2892dcc75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a99794cd58288924c0092f5c3ea80ecf0b48ae52053c3d3f95ab710d1ff6cf00"
    sha256                               monterey:       "1bcd00ddf2b127ac23a6af510eb810ede409db73d60b763b5e162b46e294358d"
    sha256                               big_sur:        "7974cae618666f1386b0f99c46430906cd05c469e5546052ab47d6d89b6a1b1c"
    sha256                               catalina:       "94335d505586e39e261d66d945b71e794f0ee46b3383a876dda34f1536de9d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e31f29497d1a5a42350b068e5cb96513e0d3a2a9731fdd3bddd880be137ff545"
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
