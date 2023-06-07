class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.240.tar.gz"
  sha256 "9c2e817eb44dae7fc70ae9fed3b2c9890019b22d7b6d82c75383b07d3aea0f07"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0506b2861f72110e39b0dc07da82147eea3ba1852bf73008a263c9b5d14c39f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7afdc990dc80ca324d1d477c73ba96b9c159176eb6ec02eb380481c04dee4bad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad8294283e42940f52557bead775b8156f5bfb09cd0a23eef611ea02703d26c2"
    sha256 cellar: :any_skip_relocation, ventura:        "1e188433978c14ac043d518390af582425ccd33f05b892b955b90f82370c7e7a"
    sha256 cellar: :any_skip_relocation, monterey:       "7ceee06ddd7ca41d7031b9a75a03252e16f16e333258c46d29ffe7eedb2502c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1257b7b7a046580e08c708ab6abafd92e8347083b8936f4b4f34299f9ded9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e53d304578541796fdc5adf913008deaacf50594108d513906444737a3eb87b5"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
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
