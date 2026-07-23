class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.73.2.tar.gz"
  sha256 "3fbfc4eeed515ba2cbc04c2094b8f99033cd9ec3ec3bbee295136c45d401cad3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9e68e8c42e7c4f4902d9d59525d287eaf800988ce6d28cd1174d904bbc431e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "582d20e7687ac1cf22f19ed7eb7e0b425a01ae007bcf3df58e9851201ab3d8a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a829af91eef1aec7c60c393683f968b1eeded982bbc6d4fda0957f879da7cbe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "763c11002d8774e7327f3d9a503d32c98e15ceecc60105a81a97f3d6e08b25ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23088a0eb17f2b54355caf76400d76a018af036d267c9562bd57076ba2897bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a76df59504ce68a2b9979bad9740eea9abcf12cdcf90d14c91c228e4317957a2"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}]
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
