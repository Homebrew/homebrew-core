class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.217.tar.gz"
  sha256 "e43ec4725137af69d76cb5e1aacfd66490ea82e7d3178874beb994e9f8f9090b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1106f6ede3bab8a8b078fe4f91f7fd98651f627ea2bcff57de50e00772d1fb52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b966e21a6141f692b6d74699a6cd64a14e6eb54796ef974d175475a90541365f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14c08d749892433066a6a86e7bba76dc6b7abc05bbef634372df5ec44a8dc207"
    sha256 cellar: :any_skip_relocation, ventura:        "f59a0432e23f0bf79d89036e1fc4c76a05e427a41557eab423733fb254f34442"
    sha256 cellar: :any_skip_relocation, monterey:       "3aa47699478ad99e6e464aae09851d8dd6beb999ca893bf25592745aefcebb5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ac81bf3bd16cada37ca89be21184ede362a64dc26cd21d02e35fb2d8d0e3713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3df3e8425b580d9b22dc759abcdee5c0e5a2e7ddb68e2b1cc56904af699e7eb9"
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
