class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.19.4",
      revision: "416b9919b7cda19e6011bf16f964fc149595c0e4"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "631ee0f44aae6a574b76e36c382cde8825daef77ed04ea19e296d206bdd00d1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd5ccc73235cfbc9d303b6f1dfb3c8de092af5e05f56637d0248482eeaa903dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60b3ca3cd64e3bec2068b9868dbb22d53ef6ab99ac385bccd8ad752a53f04f25"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ce471b2f3825045ef945a66575021ef1b60a93dd9e9946aa0067b35612cff95"
    sha256 cellar: :any_skip_relocation, ventura:        "1985a39cd3abe0b0709287a351edd2d9d85db6516ea56bb5cbc883d8bd611776"
    sha256 cellar: :any_skip_relocation, monterey:       "e9a3e6bafc5d0699924014ce2502c99c7d52bf0b94e82a7ff6a7affb72da32f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7024ab3eff717fe9ba25e18f1ed0973f02febd67446924e13bd080b8ad76746"
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
