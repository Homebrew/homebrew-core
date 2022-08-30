class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.166.tar.gz"
  sha256 "c88c3de3eaa0023be5e5aa94114fcc9fa32074dd64f9a9490c5a8bc18e6849d4"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c3bffcfa24b86290d99c261412e9e8ce9fa6c163d9e17a66bd41d1f00383f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55f58331449324b0cdf7198f335f50e55cc89b54d9f1b5483e6b98ee7b5ad8cd"
    sha256 cellar: :any_skip_relocation, monterey:       "6f4ecba13d2071e6561f58c7fa614de6b1748805486765272cc4a76687f619a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e13aeeb68e3dc669a1e82f4abb76bc5926bae28185f2542218d99cb50a118c0d"
    sha256 cellar: :any_skip_relocation, catalina:       "5810f8f56e565cce5bfb65f0d01d45e87720372744bd7f82aa7414ec66aa278f"
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
