class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.160.tar.gz"
  sha256 "1ee431d3afcc3bcddbf57ec7c77100bed74a1f89b7bdc7ecd198f36b1159fc4a"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9e9175d9ff53b210ff597a55c96033cb8b146e99388425fe75e0556934e44b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adead90f9ce4c59092090e57fc430bb4a8a0c9faa720abca3b10df2e3e2bb02d"
    sha256 cellar: :any_skip_relocation, monterey:       "ef0644edbe1bd548af357f761bfb713714ee64b638c87273a0c08d605c8fc0dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc34f61a88dc79a682a751d35c66f59416d1a6806a9fa4c88957b8ffd8cf142a"
    sha256 cellar: :any_skip_relocation, catalina:       "56211a45c8769c282c8ae9668432614494940959c503d215a75d7b4ecc21cc88"
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
