class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.9.0",
      revision: "90cdb19813b8a6137833741025fd4964abb8a024"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3566b4e97b887c6a47878a1e05fc09de3628f352abb1fceb7dcec3b34aaab48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47c0f3f47d9c4f403b9037b13c15224c6a74f80ed810c9f79d8668ad1be0ad58"
    sha256                               monterey:       "09abb354f722f3e66abae6e2fbdc6c024801ad01657fff3ea8345382237ff139"
    sha256                               big_sur:        "0802e835fa36ea3d792c58922e5611557ac1f9b598b68935ca84827e0c56f625"
    sha256                               catalina:       "8ed4cb4779cfdd332f2c69a09f6d76111933fbca9926b28b96be9025645fdd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76b5c26ec4eae342a3b123738532c540d4fe06b97d7aa98890470ac5cc5cd29"
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
