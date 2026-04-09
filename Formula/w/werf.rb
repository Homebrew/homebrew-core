class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.64.0.tar.gz"
  sha256 "c869447ba8ef1e47e0ae537ba8ed88d056b086614f488188d7f5d040fc66b1bc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa2d5509df759d79cf0b92feac3fbbfbc1cb16e05276bfa752a075da71b3d952"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57d2c3dd40b8acbaa1acc3d6403620a3c1b5be574496f946a8748fde2f43e8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e69bf01b10581c7e4c7a0d524460c1d350d3084280a7d61ef6b27f6c403c4167"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf6566494d215ce35037dbdc20397bc11dceeb6efdb7914d5d84e4a5bb78a99d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7517d477ca8173f032610547752552f2ce0d1203887e2fd801fde84f959ca80c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb1a7683f454749ef734fe3122cc69def819e354d2393d684bc7c681d41a308"
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
