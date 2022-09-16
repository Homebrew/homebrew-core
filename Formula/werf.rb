class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.174.tar.gz"
  sha256 "4ce7ee0c6c561e8ce89df12e229c72d04834c28e00f311644dc2a85f0b2a8dd0"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dffbe6e3469370c619643cb4508ee826aabd11909155134232c8ded354e538e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8787ad261a8edcb2816b5c8f5df4d09843fbaef09da9a8f3753e0c8091727cdc"
    sha256 cellar: :any_skip_relocation, monterey:       "38adfa4c9af01e2d4d4559470f25a55032a884b032a4efc71bd6991f8ab41150"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8c57ad483cb8294d8cf90acbd3d025b27e6867f86e3f8668e1dfe2d0800c0a0"
    sha256 cellar: :any_skip_relocation, catalina:       "a41f4bf4753fe9daee5d15d1bfd5e74be3abb85626ea12521d2466fc4a522424"
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
