class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.30.4",
      revision: "8770824aad31e41e69253f68f01f1ba01ea91d31"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bf3479cec0436e85b7ab5bdf9afa4a8a4664ce37ee2120e0aff01abed70c3a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a7fb3fd85bef2bee868b01af4b54e819aa39bf82c2556fb577bf89467e8fd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "126a1772ab4e5071c3eb0c97266c35008fd4f59290ecd0712dcd6b0954c921c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "aef7da6ea3a7af882e75c061d69bbc4905533d4fd418ba743d999a44a2bf37fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d957cc21c4b242e0ea68e53037c4b3e0bd3318ae5184691e54c864428f3d284b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7b499da33f762ff1e4780f18ff967f2d1ef15123d139cf15a672fee3e7f89b"
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
