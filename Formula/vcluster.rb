class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.15.1",
      revision: "a4676e37ecc14a63671e424f935189f7dcf410ff"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d29413c02863c2a7d835863348324ed013bf4dbd2112644fe8143bc2c9f03f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3e32d2120cf0ec885d2223f886d80b7d20c44e464413ea3483f452c9038a79f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88b93c3aadd1be07805b4cb8a916969fde5918414dc873bcf1e00387ac90bbdc"
    sha256 cellar: :any_skip_relocation, ventura:        "5236bfab8175b43647ca8d347cbc5d3474215e1ccce427e3b9b75ce011e07b51"
    sha256 cellar: :any_skip_relocation, monterey:       "b0d5ce3c929765d2941d75df9d13b2cd1c25d72718d315de9297ad32126efa40"
    sha256 cellar: :any_skip_relocation, big_sur:        "daf41caa5124e763c51c492f6d3e42a7a690302e651f127917be0178d1ae727e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43d6fa35c63c18130e0f6e4dc738ddeebd2a7a7d4954d3df17c7ae8bce41ae3c"
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
