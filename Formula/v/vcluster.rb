class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.33.1",
      revision: "ac04311a85bce383aacdda0721408e98f8ef453c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fd529461e1335c809a44763158e2d14ef06ecb58863b3174bc16bc308f20bd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d988b4ea093f783af67e609f9d2c7d03cc3a3a22d4009e9e82e9e2da4bb4a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83338360751eda28c1e4a959e3bfda594f113e59851b52109853705515c316d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d8298f83793bf886123eb1bf02576961dd79627999a10cd03eb688d92783c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "499ad54b991b497ecdf5088b2c782843ffdea83181e0349fc6c3560bae70dab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41103b25d357435fd16b885f77266dcfdc660703cf29aaf077c2e2532d7ce724"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
