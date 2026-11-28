class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "d2637e403b183d9aeeec795fbfbc71aa2bd64cc35bf5792dbd069e219123e7e8"
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
    manifest_sha256 "3429d193e2a40e2e8c270937495976b6ff51b3eb0677c9d923dcd404ed7c50b0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33e718110c9cb2e37b2706a15350971ba6b986d8ad8f1777e01334ecb3e001f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9b236ae64c497f8d83537c096f959e87aacc81157982f48f81a1ea2b7d4ccf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d43a62d4d47a5cd898ed7ed66e714961fe2d1fd5793cea32747e51fb3572aa3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "13b5a404cb2b75c5a1aa15b13640a61dcefd5d915c7f827078e5c58e70a704fa"
    sha256 cellar: :any,                 x86_64_linux:      "e4a99cb5acabd972031ce98652df83f27edb53a29c65aff91742da054ba564a0"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  deny_network_access!

  def fetch
    # `go generate` downloads the disposable email domains blocklist
    system "go", "generate", "./..."
  end

  def install
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
