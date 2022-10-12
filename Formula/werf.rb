class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.180.tar.gz"
  sha256 "f69784435cb86b90ea9979fce56f54e8ad4129e7c26648646b4b329e61cc7e90"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b49343fe0e2255a30cd5e469c3a2aab7d1fde80e7886969e430c6c259199eea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4911da9f022dfe81efaf58b81a00f0233e4435371f5a398952b1b61cf9126ebf"
    sha256 cellar: :any_skip_relocation, monterey:       "f202d3db3c5ce8dc0bdee5d665326544c9e48168b398525671577d3badca6846"
    sha256 cellar: :any_skip_relocation, big_sur:        "3551050b3d4ea24570edf407a7c2e763c8394590dbcc2d5274081fc4718a1e2a"
    sha256 cellar: :any_skip_relocation, catalina:       "da06ed1a243f6e4aebaa86c04636364fd9fb7e12c3d68806b7e1badf3a2b5700"
  end

  depends_on "go" => :build
  # due to missing libbtrfs headers, only supports macos at the moment
  depends_on :macos

  def install
    ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
    tags = "dfrunmount dfssh containers_image_openpgp"

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
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
