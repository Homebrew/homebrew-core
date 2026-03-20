class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.33.0",
      revision: "69cb3ac90e5d8f25ed11ddb529396c9c7682c901"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5527f34c4c49dc83629bbe007f0a9373157b567ffd762e95facd2c8e46f30eaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6cf7fda77e985a31d7a44d5dbb8893970f0ed467cfac9aa75ee25d89b04d40c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88866f6afd4489aee94a7a844b0f465333e557b701b087d894716df56673b3ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86291ea529f829a9d371227bca48865fd4374672b00a7400aeb0ec906f3b262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5540f5ad914acf10ba095b0c206046d5c03c54812e3048718c85495e020bc7fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42894a4a3d6e6f08668435530a2466b2f9d895123450f18c0437373b37222487"
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
