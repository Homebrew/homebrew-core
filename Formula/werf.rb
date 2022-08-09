class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.151.tar.gz"
  sha256 "e65367d042a537bec28b2811b4d678c71fb9632cc27f6e80568f7fb2b9736015"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d3e7d4e383f1803feb61572753d5d5cf9ef0abc9bae81211189c89654227d99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b6cec7efe9e17110d4d3452f7fe9ea83a6a3424798bf3be648f9aa21dd230d8"
    sha256 cellar: :any_skip_relocation, monterey:       "687d9ddd4ac4c5fed462e425d500325d79353018dffad9c9457f085a3b88ad45"
    sha256 cellar: :any_skip_relocation, big_sur:        "c25ae703d821e32ec8d75fb25bf2515e0a58616bb47741a536688579b72e11e6"
    sha256 cellar: :any_skip_relocation, catalina:       "35ae40e7d669b4c3b60d22d1c61b23df798e3533bb5ecd39c49f56230e70cf8c"
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
