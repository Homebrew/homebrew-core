class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.15.2",
      revision: "45db0d826d5c44294338ed442f4c1e8f142586a2"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b422717e4ceb3feeb20cbbe08085688b8befe4376310de48979e4e43b074b43f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "202f47eabf013be4cd72b15e06e45b02c27a20dfa6cc552e8ebb5b1cdbc7e3fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d14cef4e0f32f7cb2ba38c19cbd57882e0731e5c2787a7b8f4d3532f66551707"
    sha256 cellar: :any_skip_relocation, ventura:        "2c1daada9c428635e3cc8b06e2e99038e0b779db485b8fa8be799203603cf1f1"
    sha256 cellar: :any_skip_relocation, monterey:       "e8a19df740af580156057a4f3c8b746d443da84282d1a574576f63ab8e2aa963"
    sha256 cellar: :any_skip_relocation, big_sur:        "8feaeffecc77e28586bcf32c3b65d28a849f0880f123e7c926706afc0cefa942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab2af59f28d92dfec5dc6258e6ad25cbf350ee1b62ae691fad1c00f70796cd65"
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
