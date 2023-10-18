class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.16.3",
      revision: "aa59672257a8a1e858150e4e9a3c656f89c4c152"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d81737f09f7315f0537b1bf5e8da20ae41a40a741e1d6001e43a3b5410a495c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86985ec45d7a43753cc59f1ca0111e9d13d9c6173a2f623ec7e9913ae8d1a797"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9816626d7815778da51e6ddfb01e42db563a18ea67f21d0f1b422d5d78a0bfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "8859a07a3c208df9442c2f034e88b5c40b115dbaa55d42a04aca851c10046ba8"
    sha256 cellar: :any_skip_relocation, ventura:        "fecae487d1f71274952df94ac8b58310f7597f511c21ef79e11e0919e1a6e239"
    sha256 cellar: :any_skip_relocation, monterey:       "8190c44e03691570d5689bb553d827ecc800bc6b904819655fcf64c2347f7282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af88a56752fd632e2359643e6a970830b3fc330670ac645cc2590078dd8d3227"
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
