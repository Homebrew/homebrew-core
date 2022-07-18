class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.131.tar.gz"
  sha256 "0d7ca900548bb01b5866ccf246ab2ca9a24cc0b9186092aeb3118a055e14600b"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a0115eee200b6f067845b0f2c7622b8476ff95f0e5e3acd7eb7060e2f7b90bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75476ced48b93687a37c7f56bc2bdaf553b7ef93e040718f06e5ac5cc8c48aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "755372121ec4a1b41f1bb7ba1a546fe01ce6f13618abc7398e4329c43b91e4c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4e2bfed6e66d881c13ffd602674ebfc9c0dad39e36ac95a8de5877941d1d364"
    sha256 cellar: :any_skip_relocation, catalina:       "5307dac4387da0fc3ac8f35f0029fd5431ab15069812e7fef42f63a3293bf1f2"
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
