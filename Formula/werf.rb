class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.141.tar.gz"
  sha256 "b4a8eac457f1f4732ae9aded5616da969e57f1d5bd2e924695a62141102f745d"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68e779f62b0513a7cd4bb556077615f5eaa9ca60d43bf13506c26fd4e4087f4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de38430f1a3a9730bcf4f8cf93a9690959618ecfa087af736c69cf72046f7945"
    sha256 cellar: :any_skip_relocation, monterey:       "49f75ff5dd2de46b83a02ca50abe6b6ac8b3fc9347842f4b5e66a9726b1ceec7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a86812fdb079b935f1e96459ad7b526ddcdbd6c67fb6680f312371608199d8e"
    sha256 cellar: :any_skip_relocation, catalina:       "b0597ec18dae557c11098fce2b1b8db814844cd28c86c1ea331345b8d348644b"
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
