class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.16.2",
      revision: "97dc8821728c9e6886c9350ed4c91150a456b989"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58955741de2f2f84d0a6820086eb908e673fd93d128f7550692d5ecef63054a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33f85d20d5ceffa9f2d7baeb8e138bcfe62462a6d6361658395b323a3d54c33b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d7d2bb5de04543312a99e3ca22e1db0b360f3f0978dcc6dff8d8fce82b5a56"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1327592a85634c3a4e680df15e85f2888978627a248c6247b888d513bd9851c"
    sha256 cellar: :any_skip_relocation, ventura:        "9e7db1168ac473289aec3ff7c8a61b95e415e8d917a9efc5eb1c785654551d37"
    sha256 cellar: :any_skip_relocation, monterey:       "8a975515dbb470a6b71f5c9100a7542a4eb9d5ecbcc700b4ffc1fbe191804541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdce34c7502d8ee94e89f6f449c38b682a68dcf8dcae9697e47d7f8ff34434bc"
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
