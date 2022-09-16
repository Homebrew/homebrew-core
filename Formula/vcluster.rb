class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.12.0",
      revision: "eba499bcdff242e4ca73c9450020f9fb4ab9afa7"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03fec4fe31101046f722609eaa18b8cb56c52ff0dc30c5bb53d9ea305dbe586d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eaafb6de49a4c966f96d710202a66f0bc63aaeabae31354f67d5f5d7ef3ca54c"
    sha256                               monterey:       "9edea9d99795dab63afe90c181b2f6d16b4bd1ed4611a97b9f2425ff1f2d0bd5"
    sha256                               big_sur:        "63e20c3f184ae9eeb2d3696c337cce0b09ab8046e3a791ab05e496b45d186bf3"
    sha256                               catalina:       "e117c7ae15a9590b8893aaa928bee6e2efe90f305e778f5f9c7e82db6a53892c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ede12f1c9298a4831ec0ad567f27d711b09577beba4abc0ce5c918a29b3ef9a8"
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
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: ldflags), "./cmd/vclusterctl/main.go"
    generate_completions_from_executable(bin/"vcluster", "completion", shells: [:zsh, :bash])
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
