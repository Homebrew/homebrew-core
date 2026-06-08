class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.34.1",
      revision: "de3fcb491a58159ced86d98aae5a71421abd0cf5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67bb4c1e7b8c1b74623bb973d558e9cea5124d36ecc7b4f68adbe9244fb3dc61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f89101fc2ce251723c6bcf3dfd303f656b00c2a9f6e6815becbdf0a7c3de617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b3f96601f6050fd926889b99796c4f6a6a3ff6c21b7f214047ac2ccf7147ac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c47a217579cdd923621fd62e146860f4237dc8f73606cfb502359c52554b16e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ce416c67096dfdfbe9c56990d4576d3d76f50e6830649674f9343fcc4d78e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "445748165918091ab8448fbded1bec4b3a5e3f60587c74776045d80abae94dd6"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
