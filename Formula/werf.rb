class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.170.tar.gz"
  sha256 "e7febeba9a65f10cfe089be9d88dab9cec127456f6724c0448a9d605c371bc15"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f6b20fda3d63c4aca938cc6191b6d3ca6f247c7ed2444c20a32a78e99b62b67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97b7c25574cbe118e0649b4edb2d340bb9c1cffab4be13198ca9d48db7782a00"
    sha256 cellar: :any_skip_relocation, monterey:       "4546326917e6440cc4929a1b927905aef9bd62d4e378333bc547289eb6755d49"
    sha256 cellar: :any_skip_relocation, big_sur:        "85e01dc2777b1ad8992d3f36bdfefd3cb772bdfa9e7cf789a3036ca680ed35ea"
    sha256 cellar: :any_skip_relocation, catalina:       "efe1dbabce35ecf3e16b75eafec3f5c8c3b992cd37b773e3003eff2d1b863564"
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
