class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.140.tar.gz"
  sha256 "8305787a412fb802917364810b5b6f487312291ee6bd71ac24f1ed2d555770aa"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "194d63559127853db769089b08d9abdfa1922d9594e2212fc6680eb7c7f23924"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcfb99ba1a40b29cf53b74e4c5243fdb671bf609c7d2df15ed996ab46b43a4a5"
    sha256 cellar: :any_skip_relocation, monterey:       "738ac0c903b21edd80b149a6e520224652cf40fb6fabdd36fbaa4368889debe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f4a1ca0d2b3c2972f8e45169b27b6230d1f3b42501d2ed6df581e9651ebff0d"
    sha256 cellar: :any_skip_relocation, catalina:       "d1391e07f7a9c6bcae46366a681ecdb15d938973f6dd6edc89fa454ec76a8803"
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
