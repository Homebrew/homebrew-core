class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.142.tar.gz"
  sha256 "f19e97d60fe1bec9c58a29422538eda68398c6f1b27de7ba34918f26936faa6a"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d72e0207215f4c8889b6b0a273cf7cec944a29c111f472ff112effc00b3aba27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8748dcb81a38afe55b55bf2d614a4a1d7e6ec0111144d772f5adcffffe465e9"
    sha256 cellar: :any_skip_relocation, monterey:       "152e2cf9dc000c79440308fc84587e6a5515c7535947c4a0de23143c958c691f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e85ce5062bae326b01e627fafd4ecaa86028fe8d5290f129378882a3058e463"
    sha256 cellar: :any_skip_relocation, catalina:       "d0e87bac6edc639e5dbe8cba303c0cc495e3ba9c6eb06e347fb6ff09ac859764"
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
