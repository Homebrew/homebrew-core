class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.75.3.tar.gz"
  sha256 "44efae6e7542a7d929fcc222000f633372239ff24e3d079beacd980adb461070"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ccaca4e9dd17613a3436da023cb8f5cf82fbde35060f0f56beaf45bf4691abe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a28b9813a91c9bb002d321651fc4f52536f5082a03b679983ead7b5eae09e3c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eb00da6f89ae458b1b9e82cfb088ba0cb133d18e047694fa6797c47ebc1c5fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba254c94cbd8a0c3b9e078a34756de81c617dc6320fabe61a3b71e169a3d512d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "311b9b44c3db926a5ddb1a285d7c9209ac5b16432d4406d413caad8bfdee2d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "415197a216ce03dba12ac077c4b7c9018da957007bc14fa758f31ebc12da9507"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[-X github.com/werf/werf/v2/pkg/werf.Version=#{version}]
    tags = %w[dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp]
    if OS.linux?
      ldflags += %w[-linkmode external -extldflags=-static]
      tags += %w[osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build]
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", shell_parameter_format: :cobra)
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
