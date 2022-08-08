class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.150.tar.gz"
  sha256 "2c684b03c9a5a2a367ab81fb557e59dc6bce5f74800edd0d2f3566a28cac93c1"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac37a5edb7640ae3e7318f167dc1dfe3b5c2e3b0cc938071a31d6e653889a786"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3df6140f8eb23dc8a92e8302cdc19cf9ac650e5b2a82663d427b380652fd91b"
    sha256 cellar: :any_skip_relocation, monterey:       "d9c36bf3a021672ee8adf670c8038e1a0f91db06839baa68101152bde2568ddb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d83300e3bee237e3ed06f81bdfe76d4b2fcd9d535530e38154fc2102ac64eff"
    sha256 cellar: :any_skip_relocation, catalina:       "d37c10aed7216d77f6f1c8d48ecc85f98c853b8008f09fd31d4b4c19b03b7719"
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
