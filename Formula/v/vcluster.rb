class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.20.0",
      revision: "531ed2d4a99b8fd6bcaeaf1d1f61ee78355d4892"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c412096446a34d288fc7f140550ca7c52ada8396ff1d5816bfece2c30dce89b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e9915a3574ed5e15f53ebd1e714c5b841afbed84cf920b7c37ca9f4e3d5741c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4c65ac232dc6398e4ea3a4f7469436d7953368ef9b6d9e5a86a86660fb3ceb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "185d274f863ace48d76c4566d90611e90087cebb25435c8459b5d1d086cbe65d"
    sha256 cellar: :any_skip_relocation, ventura:        "229c9a786c969210eedc7e3029b8a13506b98826afb6543a88ee18ddf407b6c5"
    sha256 cellar: :any_skip_relocation, monterey:       "8d639f1920a1e15c39348623d46d5282f93d060dccbe7c4eb7e477fbc52cb7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "654f6ce34996068cecaf667756bf1506c3f7a2cae1ab2a4865d1727b4576e10c"
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
