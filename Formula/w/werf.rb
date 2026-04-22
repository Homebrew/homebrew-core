class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.67.2.tar.gz"
  sha256 "0a5e28d718dd079a5f09c6d8ae41ac1c121c7ae61a0ad86fd12e11fc4c491f09"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c4b38194bc9b38606f6e2f6f7f50c7d675b8eb10545021142be0c80cf7902ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fbd233a0d5cc0e3039f595eb94297d919ce4ce3862aa9fb6cdc2e8ff2d3058e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783c84e9f5f6ab2858a879ae5a8b0df081b6654c2b00a63fe600212dec036676"
    sha256 cellar: :any_skip_relocation, sonoma:        "00438af44ac09cc97ccbde813934418ae3e4c781275b41d9e7c61f5ba2b75d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d0e17d14396ce8fc272a769f2b89041a14f0b3d8f7de9534b3af84e10ceff9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a58957debd97e08093e2be69aeed569f232648aba566b2c1e47890e21b8d480"
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
