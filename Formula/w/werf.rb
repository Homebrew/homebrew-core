class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.307.tar.gz"
  sha256 "025f21d41af247bff027cfde3034e564774d78b8b4191651ee6c561c40a37d89"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a080f2303fd9471471c4729de3e775f4efe7c618abaf35fa433b79fe40ad61c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5d8a150f00d3a519519fdd8b5944eb86c1dc1286cc2fabb6b6969cbfe9d5783"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e2389fde0925fe296fb6c37f63fefee63907f4ab8d29177c8c34430ec946099"
    sha256 cellar: :any_skip_relocation, sonoma:         "c522af6e6579fb7befc6da4bb233ef183c9908d8d59baf31ffbdb15bbc89f6a0"
    sha256 cellar: :any_skip_relocation, ventura:        "9f26b5b1d25f3b07010a4e8f0298a69a829232f8481e50bfd1b2524b228c85b1"
    sha256 cellar: :any_skip_relocation, monterey:       "8478d4f65519156a3a817b98cf4c99b57420639b21eb2d4eb208516ffdfa913a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de3ee0728c17d98b768ffb558d5d4c010a76b55a853b714810e64e306d26ff53"
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

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/werf"

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
