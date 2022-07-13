class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.126.tar.gz"
  sha256 "8a4edacef6646a5b572d368efd78628c2c2c65a2ff7dd6fdd16f9f8455f03569"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199ce1f6592f17e1090083124a553a6b936dfb5d4b321a4afc9fc29cb293a0ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d8479e2692b7da77d867e0a006364b26fd30e15e8012fac0b00bdc66a7a5444"
    sha256 cellar: :any_skip_relocation, monterey:       "589ce7c37cf858d20a1fc787af7414e562a41fcf28ebdbf61754bc242a72c329"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d8a2aff4d2216cbe7eee411d414ce3b0697547790e5069e3efcf2659cfc105c"
    sha256 cellar: :any_skip_relocation, catalina:       "e9aab315c7bc981295f5d2ce38352aa216f3aed2aedcab2afbf08df32eedaa8c"
  end

  depends_on "go" => :build
  # due to missing libbtrfs headers, only supports macos at the moment
  depends_on :macos

  def install
    ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
    tags = "dfrunmount dfssh containers_image_openpgp"

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    bash_output = Utils.safe_popen_read(bin/"werf", "completion", "bash")
    (bash_completion/"werf").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"werf", "completion", "zsh")
    (zsh_completion/"_werf").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"werf", "completion", "fish")
    (fish_completion/"werf.fish").write fish_output
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
