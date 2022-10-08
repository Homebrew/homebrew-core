class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.12.2",
      revision: "faaa3c96a1fb737036a628d7e311697530f384a1"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5743a9ac3882ef84eff379afefd865f66d92a557c2f1b1a36c52688eeef7f321"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58e5c94f090a7230dc930bbc16f31e538f61e412cb189416543e7b4b6a37b661"
    sha256 cellar: :any_skip_relocation, monterey:       "6edfabede311db8835fda8fa4fad5044df2c50325311933e6d40c384d276500f"
    sha256 cellar: :any_skip_relocation, big_sur:        "032ab431fe634f1dc567a27db1ca5e41ee16571e46ab105c58a236774f1a4ba0"
    sha256 cellar: :any_skip_relocation, catalina:       "85488ddcf6741e5604d6a9d5217539fd3ce1ae983b8ca3c69e8f9f09642260cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec1d1cae2b5040fcf37813a07a6f6658bf404d2c40ff36fbfcc6c624e248087"
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
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace", 1)
  end
end
