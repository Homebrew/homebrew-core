class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.28.0",
      revision: "551bda6c37b8ba61081ef0490e4e24e674bae222"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e176e0f4aedb2fa1927ea49d63e64fe3128527be797d4c2810c1dece33a54ec5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983b0a5028209ec3f96f22768e0c5453e20065cf796f9eb51679d83a57afa587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "217931a7f09ac32e9e8df834668f17eb03385c95dd3e75096edf2d8230a07fe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9f34abafca7d86e78547f5cebda302bd68ca91c594c4ccd90a3c05f3538d524"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce156e52faacfdfbdd575603002f35d9034e60698795e42ce5d9caac3015d1b6"
    sha256 cellar: :any_skip_relocation, ventura:       "fc7ce0af6735a19ab388acb0fbab08edb2d28ff8ed5c3d62f411da992e05ec48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb1807de07cc47bcf65155858ce7122ab5aa670fa5ac8b29dcab9d88e004ef39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56545041866c2871a1bc9b94c5e261dbe1838292ed59bd278a112bd2af6d44d1"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
