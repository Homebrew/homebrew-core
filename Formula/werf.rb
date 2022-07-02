class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.119.tar.gz"
  sha256 "36c990229a21631a19c9bd46d90398bed0450a444c2876e45175e5956c803d45"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd82a741b31d93c8e94ca22fa43a73626caf94838e0f3093b59c1bc246c5d4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d1a811cce34d9d34fcbb9cab022e389b9c2e52213c0ce6a9c205473bc3abf2b"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a2af214d7665e8636b9837f1fca809d0f9c030f85e08fad4d2707fe5eb775c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c972f4b682302626c939c780cc7c22840950b5d471376852089f0b8b5e164db3"
    sha256 cellar: :any_skip_relocation, catalina:       "32b2cd172eb23726616d2fea26944b0223fa100c7c597770c7a823e51ef68eda"
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
