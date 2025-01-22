class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "356eb37f7200315d1d13982f1b8190685f2675270e2296abac907d8055af8fbd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883490a498925c6869c23558eca95bdfdb50c89032dd36590742b292785bc75f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa78efc1ce031833f7784448b8a18f476291ca41e9334229bf6742896dc85e85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aefce734c060eae0fa22bfb83ab402c39843e6a295ace1ef8167a00bffbae48"
    sha256 cellar: :any_skip_relocation, sonoma:        "2913c9a70fa673f00d3190bbf4b976da9eb60dcedc7a8fa272f0743b8248df74"
    sha256 cellar: :any_skip_relocation, ventura:       "2d6ca384f0212499277f45ea492552f83a6576b0354dee4ca01c5d485475d0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301430bee7aca9a62e7787f01bbf02aeff828eed1c4350dd24b3b58458249bcb"
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
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/werf"

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
