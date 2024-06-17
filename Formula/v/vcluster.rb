class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.19.5",
      revision: "38a919a551838204f5d6298d65770966ed4629f2"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfeeaab3049f379192d40162a8d7c4215c294f929743f8d630868542a43dd60d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3517ecc630edc52f7eb4a7239c043c9af01df852191be1851824629193845f94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a9f3dc8eb8f9a91cc8e9bd276a020e93f9e8dccb13167989134b33d3c4c982e"
    sha256 cellar: :any_skip_relocation, sonoma:         "17c3be35d4d2cf026e8f591428e2522e300898135d5f63a15accb336b127b9bb"
    sha256 cellar: :any_skip_relocation, ventura:        "18dcb74d0612766699d6d674aa4c037b399e8f66807be5295c798a82142d3559"
    sha256 cellar: :any_skip_relocation, monterey:       "445f62862149ba086fb144cf0c68aaf0491356b9eff2b6e90f1c64e896bcc324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aec7cc5c7f519a708e7ca28e578ea1c7f87f634b2bec9d4aa98f1b67d178398"
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
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl/main.go"
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
