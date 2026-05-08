class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.34.0",
      revision: "bb9e88b0a9e45c68d744eebe6bde5c4664cdb676"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de44896d6d0947a04982b9dea0abcbdf8b4772947443a8151e4f16f92360402e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df1b61f1db7de653763932cf3184333f6a4c65f22b9e36003ed1762415d459f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "123b5fb41d88561cea16acdecd5cc3aa636b1916157df51f6bf9f2a20a509b4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d911d8f7566623c0624442d158e93e40bd903bf863a26031672d69d4fb68560e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b540ca27ff9a4a75835b5179e97109156fe7e2d8afaab85af481a1225a4e74e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5a4d44cd2703bd790d5b1e66c85c2e5bdc358f5bb76241c6f1b228f356d41c"
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
