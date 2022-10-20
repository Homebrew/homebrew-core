class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.12.2",
      revision: "faaa3c96a1fb737036a628d7e311697530f384a1"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e1d36dee82c6725d6b0f0762d14133652cb6cde1cc6ce2df3bf0cc0616a6cd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "258e54fb0f5f063e94a7a0efa1c18430d4049ff8cced17528c12b3caa46142a4"
    sha256 cellar: :any_skip_relocation, monterey:       "055e42aa26e34403047623b614a4c58f5fd4370962b4f423dfc437e3b3f60ffe"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2f600e0cc86dbd61b51dda2e4909b3f77ba4f56153bed9f3083d62953676eda"
    sha256 cellar: :any_skip_relocation, catalina:       "28344a34534a9b9a1b1a42d9b66bf5b028e2efb254435b5225abf08f2223610a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6aaa2e5fefcb57f77dcca74b0745a8ad587e9d6980da4e2ead4f8837585d6f7"
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
