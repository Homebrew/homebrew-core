class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.35.4.tar.gz"
  sha256 "32fe89f9f8105bf64c8b9d104af43a73737afb3e9bf7004be58ab096ace21ac9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78d4183a0cd6c85f0704444bf4a505d6aa01e49e06c6ae4d06f24ad4db560808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd4b9af9effb9ebbb92030ea660a2eca1b64d47a896b655c73d1af2fa7db056"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d39820e5cd15ef73a1c4b6b52a5f4b4ca2fb5578a60a30f36824d9f894947b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "60735e0e957b4e26da861c53d22e857af7909f91ce2163aa3d39a4e6bbf6f8e8"
    sha256 cellar: :any_skip_relocation, ventura:       "2e8413978ac9544129241751e63e00ac6734c47e3da833dc1151c941711e9f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4045599906c438196b6190723343421e578ac8dda2f9119d73cc221a63809428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "711c39e44a388c035e81ae0a8bd7dad81e6cd62345595451aa6670169d784833"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
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
      - image: vote
      - image: result
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
