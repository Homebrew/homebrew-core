class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.138.tar.gz"
  sha256 "1fa638879e1de50366a53ebce01748ac3755c746a9e6cba5a5e74f7954d4e921"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6bda3c9d18db5714350b190370b1f3fa4e0262360536257be501d09c68e1fae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7b82b39231fdfecb213b9d438fc96d37e99f48dcef3129deb3d8ea4fbd9cbcc"
    sha256 cellar: :any_skip_relocation, monterey:       "d943f46248063b7baf4e2fe8d0a1d94355e18b1361a7aa0133dbc12c3810d818"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee6f5bb6dbfa4efd1877b2efb566c08a79925d1f3876b30784ceda12d067e543"
    sha256 cellar: :any_skip_relocation, catalina:       "5a3ab2732bb97e67f2e62942615c06328e9f2c716c064ca76f76a0456f33aa2b"
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
