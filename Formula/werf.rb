class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.120.tar.gz"
  sha256 "9a3c2ea9242d48f63c15341d940c85d873fe1a694781ac69446279c89ec1a9eb"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eb3e6efeaabc6aebb9df12c8485e1c9c6cdb9a34e0f81e274aa89ff3074b1a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cfc2312461ca6ceba0bf2878d518b7d3e9a29be51be6eaf5b334b18b9622b51"
    sha256 cellar: :any_skip_relocation, monterey:       "3480366b4c86828187086319cc3ea7c6fe3d20758fecf47912c65e8b19998bfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "34b0d385b1f83bc6c478ea46a2353ad8e87892fe2d3cf49f70b1b01737cf0ed6"
    sha256 cellar: :any_skip_relocation, catalina:       "5299ef57b66380da9f5490f23fa34cec07f8fd8e5a2dfb418b8445cd792b9e3c"
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
