class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.14.2",
      revision: "0dac15bff8ee6b4048b1f2c44a97eb95820d3ec2"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "669cbe441c14996e830a81ff19acdae1c76ad3ac13417313e34e54d2d7e1081e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1ee73d5d2654b00273e3bdf9b6037e725c24270d3d261ff9f1d7237cf8f2d47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9094422c9d4749518200a686395d66f047cbf8484d950853fb1ba32baff7f1a0"
    sha256 cellar: :any_skip_relocation, ventura:        "104167af89427a88b2d1abcca813c06719309bbbbddfd1b014676e25267e6ffb"
    sha256 cellar: :any_skip_relocation, monterey:       "bab4c6a99ec2f483608491be965abf27158c82ed9297e95f2cf3e646b2669a13"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bfebf3a773787f24032eb025211d22a50ff6a5dd431f68077f1bf493e327749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eaf5a3f64c0aed1bfcb62cea40065e3a43d2652edac6256c72780d982a9156d"
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
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace", 1)
  end
end
