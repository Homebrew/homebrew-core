class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.14.0",
      revision: "ce9635164dec3d099fc39c3c8faa61c1b3becb65"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56282017b444a0edffe0a5f374645848fb4c10719c2b3b76480bbfcba57965b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32e033ce04d55c0c0575e82c957bae6d09bdc0040cf86d8a0161656a16eb1c19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddfdc3e38e5b2b745cd62b98aabaaf37446bff26691685fa57b3303f541ed29e"
    sha256 cellar: :any_skip_relocation, ventura:        "606cb52535d9d33a7ff15f1a40e6f30736ff45b9fa0f8443b8ebcee1d31c281e"
    sha256 cellar: :any_skip_relocation, monterey:       "f5b07acbf67a9c4fb9d5b49f90abb46629953e5c84875cfe5bc8c38107da3091"
    sha256 cellar: :any_skip_relocation, big_sur:        "f115144fb48ddcfde83360e38c907c02103255446832cc3c5333d071a8a2fcfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b024a96c11cdc27f5c9263556b2de7023dae2e5abde37b223bdfe4235b25a6a2"
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
