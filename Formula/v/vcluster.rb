class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.19.3",
      revision: "de69d0858ab77b31c3ad7c41468ae982938b850a"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e1aecdd524548c9a32230f4d9eb57a437223b9896ff406baa5c042c86305829"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b38b18856ffbbe95f70fb6d6d252399cb34dfd982fe734e83e880b04f96ef11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9c62ed06f41470853fb481f7af866f25a5f80a303951c7cd34b66417075615a"
    sha256 cellar: :any_skip_relocation, sonoma:         "33cd2476a0b5f11826f7e99a44aac62628efc0536a0fd4e86db37045e3141877"
    sha256 cellar: :any_skip_relocation, ventura:        "989eb5abd0efda4409d96d2c2a40094b29e2ebaf477f38071883b7e83fc32577"
    sha256 cellar: :any_skip_relocation, monterey:       "a014256d301f11f63a8c81020a504cf3badd2a1c7f4cc6416196d8273c0514ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30e9acb8a9a7b6a1258742177ab8cac5afd1d07570929ea53c9868cee88c6c8b"
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
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: ldflags), "./cmd/vclusterctl/main.go"
    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    help_output = "vcluster root command"
    assert_match help_output, shell_output("#{bin}/vcluster --help")

    create_output = "there is an error loading your current kube config " \
                    "(invalid configuration: no configuration has been provided, " \
                    "try setting KUBERNETES_MASTER environment variable), " \
                    "please make sure you have access to a kubernetes cluster and the command " \
                    "`kubectl get namespaces` is working"
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
  end
end
