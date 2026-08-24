class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "9c290955988cb609f16e0a8b72a0ff454e13a9521414641738731f6493b83c0a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f7cbbae380abb2789619a34ba51d4f570ff0ded069034ef9fa502f69d814692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db413cddf2519a1d6a3df66863677276200b4415a0790246f8fdfaa3c99c95c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c16e3f987bfc01db3abf545a89fb7998c9a695b994d22e3ac34dbdf17379287"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b70a01d35b559424944d5ed8215e54d9a7907276198dafdb9262918b09cbbae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2cb391979f3119507d8a100f0a9b44a7d885047b143119d72035151b18e0ada"
    sha256 cellar: :any,                 x86_64_linux:  "10944349f1ffafe5556c3f13fae18529227251480600a2c5627b8045b1385c5f"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
