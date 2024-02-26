class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.19.1",
      revision: "63a8e2b426017874f7ffe08076ee4ab30a41ac0a"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cce108168c3bfdc9ff0ef6ce38e58c9e2225ed33ebf4c14670723170d3721ffc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a34c1b393d19df5077c6d0a38f0552829011864f868daf9d8f953b94a4788f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c59370057c899d49c9575f8a1ca0b947d9e0cf899c74eeca8ca0afc3e9450398"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cfd689a401a12fcdcfa84586ac32f12b574221a76b82e0cc933b29a9430e719"
    sha256 cellar: :any_skip_relocation, ventura:        "f3b9170b8965c2e2503875106865fc6ed158b9f636b81156bf0c563e67f90556"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7241e99b2d0f01dbcba7d1f070432cfecdc549a391415656684e857313161b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3b1e0e4e02bb336cb392a9191301b397505d462f6bafba5e5a45399013850f"
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
