class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.139.tar.gz"
  sha256 "931b13bbdfe1784bf03c7362e70a52674510985a6ba79f24d4d60dbbd69ca3ee"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99c1869d6c285c1fa960377b3502cbfc9f83672d6d0d88130f17d7fa352b0b16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c368c795c9248b23d38c9aabb2e3d8915cc36d8b213a6b7e7939c573dda875e9"
    sha256 cellar: :any_skip_relocation, monterey:       "d828bea62bdf3f338643a959dd88c85de7cbd2fe5ab2dbf604dc0060e403c2e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "15133a3a81e8442f66db5037b33cb1cc2a1dbb720601c30bdb071b0e783090f1"
    sha256 cellar: :any_skip_relocation, catalina:       "cf02668b44c47b990252301cfa3b8088339bd319dcf054be2cddbee9218dc17f"
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
