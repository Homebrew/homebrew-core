class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.12.3",
      revision: "397d9942f6f05ba7ca1dc9d507f26c8e33cd36b4"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b66ddb35fbfbd3748bc579a6e7bcc150a46191561250ef618a88ed794b87b84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80d8611bed2c1ca5794bcee585d2af2d585215c52508a6238db48a6ea9d86160"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38251ee9876db32b10d763dcdd86f24bbe15ba21ca3f27222bae74de7082f422"
    sha256 cellar: :any_skip_relocation, ventura:        "803a68f9afc5cbf0dc81c02e6d0dbfa2f45669877f505ed4438ab2d91eb94d39"
    sha256 cellar: :any_skip_relocation, monterey:       "5641eb19d7854cb75d3aff26603e51721f920e3811ea97e1cebbe48d0e5afea7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c02f8ea6b39e314844a0c2d643725fc666ecd43b553f6fb0aa8a6291f1e9aa51"
    sha256 cellar: :any_skip_relocation, catalina:       "6939a5da214b63d733649678a4d4c208c8d2be0bca82bda16b6918a8c57a3a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105bbdb3025ef4cb23f27510788bc5ea5081733f72cc5faa5d2ceacb33ec8fa0"
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
