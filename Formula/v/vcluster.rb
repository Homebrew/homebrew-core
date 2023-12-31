class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.18.1",
      revision: "52581de84156b35615afb134ab7e8e992da8d97a"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "093d037a3400be4ce07bb2571f77e57bec38762c0bb8a3d17e1de54bb4726642"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2e1c859f5e48c907feaf3d6431af2f8f5635bbcc7c39161519930de7493ce0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79075ac6e0a1143b8a6b4fefa6008db941e05289d1348d960efdd28850320be"
    sha256 cellar: :any_skip_relocation, sonoma:         "b31d619a88deec7c16027b1e07ff6e0e3226c7faa8225fb77054172d50fdf043"
    sha256 cellar: :any_skip_relocation, ventura:        "ea61fe29d8eeefe2f4a9f64a2771bb5d6201a6d9240404a26034790713b6b103"
    sha256 cellar: :any_skip_relocation, monterey:       "88f3fca3ed1e88a055eb93dfc7ce16dcb84c1b192899d8c221fec2c987e3ad16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a9294ed0c40c1eed7d6ad014e183ae4b09afc7e83f937d2fa3ccb162408f7b"
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
