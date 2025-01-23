class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.22.3",
      revision: "0de286ea6ddb99f30506070f9acf2933e8cd2adc"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45980d659039336ac35d25f2c7157cb6572bd6230264ce3eb73552de307e745e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "958388187080df5c4952ea455b04904ca8d64640797e1f1f5cd6d315e7bc0204"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eaab58fdc2ac6ac973340365aaaeddb51aff9ed1194ea64ddf2bad99517ae8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c375c50289322758dd50e8353c40bbb3d9607e9fd9d932fbcc2cc3482ba0209b"
    sha256 cellar: :any_skip_relocation, ventura:       "f91c2a51c57075447e236d9d482f4e6f74331c9f0ab75e7c218ea4f8c99b5e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be8d764a48f3c1c3b84ff50941da08f01286c7deba5f3740d5d9991e7aeb143"
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
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl/main.go"
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
