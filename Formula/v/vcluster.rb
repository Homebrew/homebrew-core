class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.15.5",
      revision: "c9a7c0f59af56136fc709823d33f2ae9b7eee9d4"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9228e54ed8b99162fd80a899ebee99f1331773381602f188559c80ca586ff027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7377f320662bd48ec5bfd3489190b2f52359357d0021b335019a85fc0de2bf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5da16ea7a005618c1e8f6e2c1117b5aa4a9285f5777a742735b4c8b74e81a812"
    sha256 cellar: :any_skip_relocation, ventura:        "ffd1791fc9e869f2ecf587eb0393d0f773011896babbcbfdf16d570171b2d043"
    sha256 cellar: :any_skip_relocation, monterey:       "66406c104d181381afb4441d7277161186d52e9ff77d5bdc20c1d728e4af9eee"
    sha256 cellar: :any_skip_relocation, big_sur:        "90b34df50f3de64be3df66c3a108aabd49e55672b758c9f369dab8f11d73a0db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fabdc15a7785d4b243447ff255ef571e561e17fb98ece845fab8728ac968008"
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
