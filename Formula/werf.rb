class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.172.tar.gz"
  sha256 "d4fb5054189c59e71b399f66ad03a0c46f9ad3e7088b2bde5e3a2a94e5e7a2fe"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96dc3b3c8598fe406f4835568d81e9b2ec373e6604497f18bb0e9b156e98a6f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2404281c595cd8670bd49bd45e20d4bcd6e00726548cf82736641c67f63a0d41"
    sha256 cellar: :any_skip_relocation, monterey:       "5a71a3d5c8ff0c46092011af2b4c2f36c211a51b9c1f67240c93900c3c137c4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f04ee927ab7d9792d17415103fa7400d1be5ef5d2cfc591b9d4d098571bc9f0"
    sha256 cellar: :any_skip_relocation, catalina:       "456ec78ced4236f86dc612b6211f6de178bf0a724fbe5f7b4b37bb1140e72b2e"
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
