class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.127.tar.gz"
  sha256 "21198a84ff4dc268e655730b594e66d813b360cd2ac8c760a814b0ce9497d263"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "406d3ee4e0169c071220076a7f8ecc6b975b985db06a374a1c8ce0c0ea1812bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "983be02a18b4a5e1403646aa37db87e0becdd0ac6f800748ad9191fbef923742"
    sha256 cellar: :any_skip_relocation, monterey:       "078c260f031e146454c588fbea7e97a2d9612c8efdbab58c24948cca18816dfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "6741d89f087bcf7bf72117ad321a62df25c6276a33bc989e80c878c80f0d57d1"
    sha256 cellar: :any_skip_relocation, catalina:       "917973197f25699262aa22c6c43d62cbe11eca13e8a97d4a5a9a9f6e0debac34"
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
