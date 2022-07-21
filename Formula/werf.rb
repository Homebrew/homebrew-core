class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.135.tar.gz"
  sha256 "b33f3d03587749745b2093592ba6f416bc6ba8603d3a5b50c8d1671e3664e0c8"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b2cfed958664fe1c94ecbb68984853a417c90f736d9521cae16f07865ba1da1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1549fe50d23f1a5c5602096f70a2c4fa7acf1529e1b3e5664fe90c59b5068cf"
    sha256 cellar: :any_skip_relocation, monterey:       "4b93a7103b67ff37b1bd77dc0563cfe43c5899db64051ecf2247612f31e6198e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7f58c19af0d17cbecadf72b902f57f3e2b70b5a57adf9f447bdcc811951a43c"
    sha256 cellar: :any_skip_relocation, catalina:       "656a00cd991d7eb36dac8d9f0a259955bf673d8bac8c98616f6ae4cb3c4012dd"
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
