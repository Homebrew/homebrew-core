class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.153.tar.gz"
  sha256 "d23d3a7c82706770503d73768448c2f84a23d447ad4e7b10d536b8a5741fc8a8"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4c544b743a645377fd3f4db893785838d38536d4bd2892d282289a5a9551893"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afe169e366c375b697cc1e9069e8668b7cd2686c6d1f3e35a47772a291384327"
    sha256 cellar: :any_skip_relocation, monterey:       "3f4346c97b2a77601ede5f5d1d653d4608b7f7c287d0a841a857c876be02ae8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2686e2d94d5a7d7c91790c3fea49a80b1bef4d624ca51c538c647ce0e2eeefc8"
    sha256 cellar: :any_skip_relocation, catalina:       "ffd6ab8b4de923f4a8365053dd44b37deb1b6cf6f6ef5ab530acb1f1ca253842"
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
