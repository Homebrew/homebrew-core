class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.24.1",
      revision: "7fd3db2a571227bec10e7b92571db329ac51339a"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b005910b563cbd0098eb72b9b442c36e3971f3ef97df77033fcf2713e3109ed1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68fff93f183fae65d47c2c4ce0953de87e7ba8861cf39062548c80e1af9404a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "412809142890c4ee448821d19db767f6ead1ceea1c5c3e07c3de5ec7bb7c3113"
    sha256 cellar: :any_skip_relocation, sonoma:        "88f9a02797c6813f351f2a54ea25fd43cf14905d3574a2470fb88e7e73dd1557"
    sha256 cellar: :any_skip_relocation, ventura:       "9689a6e77ccc087af0ed0d2f453d5b2838406eeec000834bd2e98bdd60ae35d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a789d6b155d17cdcbb89fd6704941e2fb87faa2bf77ab6edcdca7855dced7c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fae6905debd5356ce02ebb05a21fd429976f2367ed19ebe07d508a021bc0e49d"
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
