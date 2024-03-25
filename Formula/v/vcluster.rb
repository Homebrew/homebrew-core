class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.19.5",
      revision: "38a919a551838204f5d6298d65770966ed4629f2"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54dccfe94763e010b9d8af560b9d5e44805085cb03978017d595664ff9a76865"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7c99e0630a84b285600815d442b89494f6b805609f918d1d80ee9a18512a2ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f147f2356546b5e7561c262eedb4f2a94fb7f31e2aa1173793fe4ab86dbe748"
    sha256 cellar: :any_skip_relocation, sonoma:         "0293f274c7d1e659bd8b45b47eea8ffab4ed246fddb8b7f856990a81eef02d8b"
    sha256 cellar: :any_skip_relocation, ventura:        "10238980fbc1e14e856b8e6d97d92190542e6e320cb8fd00027cc30740e61f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "7510024848542f15362b848e1c61e2c84cc8710cf32e04cc713557b421e48624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "941afff1ec89e1dcecabbf17e6dcdc28722a03e69a025c8b9c88c13ba4c5cd72"
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
