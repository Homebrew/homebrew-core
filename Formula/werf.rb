class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.175.tar.gz"
  sha256 "b2e16fe19a8c372cc459d8133d85c6146a90e5690c9673ca8d73b5f101c4e478"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f25fb3d00cc54f126d468bd9445c13ba6e3f04e7eba287a4d702eae28c7a5e36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "590e4850b83d0ec708800244390b4a52c0f6c80bafd4c8a3b6a8469e79785e1f"
    sha256 cellar: :any_skip_relocation, monterey:       "2696b5fc0a45534b1a6a45daccecfffaf0af6c8a166315271a8935914e616f38"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6cfe93507a5751249ad5584d59c44c84b00e7b0ce1f608c343421e82645606a"
    sha256 cellar: :any_skip_relocation, catalina:       "0def5dbaf6f35b831e4b93272ba81c323770d8178486c087101d985d2abb9245"
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
