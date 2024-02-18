class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.19.0",
      revision: "d046a94bb6f7fdec7061589769e201d7e72f9fe4"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfad926c7ab81e456ac863f2ae01fdb113b44848f855e4bc43715a554ae608bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02067c6d4fd3724931363947e7be98a7e64785ea41bc40f00583e8f573314e54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "effcb1bdd2416b0f22849ca86cf9ceafb8fd11f596aeedef8f8c39d373a01ce8"
    sha256 cellar: :any_skip_relocation, sonoma:         "867d49f9e99333e18d1e9fe3fe1c03359dbf068e4bc07b675330b477734a0674"
    sha256 cellar: :any_skip_relocation, ventura:        "a6a51f80edc2ad655b9f63066fbe0f7d63482f5a24f69db45e32a7502860e4db"
    sha256 cellar: :any_skip_relocation, monterey:       "ffdcedbbd454373d48bbb590c65d4af6e9a3b3f8c346008b3b96f160c37a42fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aa5a1b01dc2bdb4e6fd4c6b5f6a2d1f6055de1752a1b08396cdbff471e0f9a9"
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
