class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.14.1",
      revision: "3475fbf2a52ede5a374d4d157b6f084ad4b69292"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aa472aa5a66841ef0dfe7e08f70c9b673cc427cdde3a37532abe64409378a54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10cd22426b41105a8a409a3096bfdb5ff1c0e58a81834e65fdbf936b142c6bfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b360a243e8e3ab6c4ce260e7d8fc4f0eb4f49ca7048b0d87f0931d42bc137400"
    sha256 cellar: :any_skip_relocation, ventura:        "ea56a0a3766b9fd6fbe4d19572b5f2e4df1838e23d87c14d829322f95f96e9ed"
    sha256 cellar: :any_skip_relocation, monterey:       "5e2eef52c282ba9b3223532946b404d4c1c1733d50d2ed8b74b8ef4c3e16fde4"
    sha256 cellar: :any_skip_relocation, big_sur:        "eea737c1414d04377aabd8173e7223d74549be422516334c9558fa5bc8585475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "978e85a4a91af52600875c9b10f32cfcc2edb26b8e4042500fa9fe0f17bedabb"
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
