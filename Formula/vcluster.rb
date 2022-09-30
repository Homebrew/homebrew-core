class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.12.1",
      revision: "86603ca11282e12dd25ecf7c8649dfc93bf196eb"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58c259a7e59a67d9359c2f805988fdf00657e9fa9d247fc85473275e41f16291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e39866d1f075e2ee00796a2f6f3f430066bbc330ea5f540e635b823be229e955"
    sha256                               monterey:       "21010b445b655663c5679ee2c3cac5b2286bd0e2a1534bef6b4dfcf94bc1ab4b"
    sha256                               big_sur:        "891c16de3f14e1c5c0127e0bf103b28e0bd37091fda87013384c4ecd7714c93f"
    sha256                               catalina:       "325f1d4a300b02200bc0e1ce9d142f14cfba243b9ae9c7c85a5c1a45b1fceeda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed74f2631e7c981a6b07e719e492851287e25a776d03bf92f9bde473499677ae"
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
    generate_completions_from_executable(bin/"vcluster", "completion", shells: [:zsh, :bash])
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
