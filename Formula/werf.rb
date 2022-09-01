class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.168.tar.gz"
  sha256 "e54ed86d40a1d2727eb882c39f916c37194c543d67e84bb222499dcec9ee5dbd"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc4817d378e693d2434bd26439896e0c21be5ac4439d964266b356f579e55af4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28dc4b412cfecbc87bb4d8370f9145f7694017916fd40e95c832e92ebd31df52"
    sha256 cellar: :any_skip_relocation, monterey:       "914fc7b2354aa95ad2705386e2572d5edb43bc7c1479385fcc6e9607b7b23f08"
    sha256 cellar: :any_skip_relocation, big_sur:        "da9c42075af5eab6668bd6380f0e4453593b4f701c4a9e01cb0ffe4a1d00d52a"
    sha256 cellar: :any_skip_relocation, catalina:       "c9e2728ad96348abfc86351f594b58d67c571826558b5e8c3c92c53cc2a6ce7d"
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
