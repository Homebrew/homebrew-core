class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.15.0",
      revision: "8c85332be423eaa0eda6da15451521ac1c6e5a8d"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc9106ccadeadb7985c6b16a59ead0d77d4acb1bc9a604e79060c94d9d9d4b2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9d3cef0991cc62d88040a24af89dedd8ef49b86da45821f11e80cbccb743a11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88dc4b2721a9c0a9cff114d7916e568c5a580e5f6b22e461ffa413dcb1d43f5f"
    sha256 cellar: :any_skip_relocation, ventura:        "5cb8b9289c5cd7e9786b9b4df735a5a86a9732d0338555c523ad7c798fd6e25d"
    sha256 cellar: :any_skip_relocation, monterey:       "49656546d1e926cad0f840a43d7df369ca121623b2217020664ddb96f143d96f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b554a2c0aed060562f7765eab64608ac2776da4a9a4c8bec4fddb34a74a7dae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef5daf7f61dbccac9ec72faabc29205b17bf50db40c1641ac943fe0305bf73d0"
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
