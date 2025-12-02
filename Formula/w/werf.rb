class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.51.7.tar.gz"
  sha256 "35d2b2d0f2706508bd5169ef1aab184d21cbc2c1d1b3daa13ce5cc01029c9e57"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa761eafbc5ef573f393ce0802dcce2fda9ed62b8ee56a29d49d8015d9f4dc12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73ec1be52e4fe7802a05da59128d9d6363245460eb8b396d1df79afbf45a3cdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "896e697cd88bb1071f31e01def45244cd228266a9af4d3207b5bd09f8b5b4371"
    sha256 cellar: :any_skip_relocation, sonoma:        "a149a375c64f474f5fa27b8ce56e624b244745abbd033c31bf4103b7aa137b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "467a2aa38df4e7ff2b9d55b8c857920e99b7e47dc0a068f9bc102af86c963fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e67a1c3e49aae543494138aba6f023590cd3e2dc0f958e7c9e782c1cbb3e856e"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~YAML
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
    YAML

    output = <<~YAML
      - image: result
      - image: vote
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output,
                 shell_output("#{bin}/werf config graph").lines.sort.join

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
