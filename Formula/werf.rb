class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.178.tar.gz"
  sha256 "524cd8ee243fa6d03e7efcbdbe5c1ae71a8b859c3f782bce5924e258b345b0e5"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4d1213bfbadb9ea679e9932acf436868dc6ed7931e6e5edd9e24e79078d29d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d0a4125fe79a7a984ba348697ac40a3af841149ed347ee17b176eb72da4718f"
    sha256 cellar: :any_skip_relocation, monterey:       "473bdf16a9cf6c100215e5bface62845d032dc125770abef7a04e8d3930a1be1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e081a0e50733cd8e586a869dad93b7d9737a19558b23ccfc223e29361867f798"
    sha256 cellar: :any_skip_relocation, catalina:       "3dd80f9c139fe348b7218205db99b2f998bf19b23f871dfd05f41bf09380ee30"
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
