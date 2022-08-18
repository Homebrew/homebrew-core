class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.161.tar.gz"
  sha256 "4464e74f39c17e2deb2bc642a4c8e1040728fe5c6468f4a8ac8007aeeb7ab1de"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c131e353b69ad795c8facaa3a92f64b4ffc6babcb0d2a3e0805bb9056f1d6903"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3096e92c3794f86a0893b96db7c32742a64d0146d2fc8205b26dd357c1b2e25f"
    sha256 cellar: :any_skip_relocation, monterey:       "143016f16587b12a587349fab87c8523fe2d9afcb66d11bb00a788415f5bce26"
    sha256 cellar: :any_skip_relocation, big_sur:        "133ead0493568c76fe15a6d43a8b2fc2ff114162ed2fa89754f425280a1d4932"
    sha256 cellar: :any_skip_relocation, catalina:       "3eeac0f5c44454059855209989b205d304e8f5b01ac811d278b0d5fbeab5d1d7"
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
