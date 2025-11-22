class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.51.6.tar.gz"
  sha256 "5382d58bbd41cf184f0d42527d06b072f15bb3190b13efaf6f7f2becdd74befe"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee7f03e4541a02634ab946c30fd7627f91dd08126e00d5d4895398cb9959d880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a95c07e2186cf793eb5bc4c5fc687c86bb052161d5bcb900334fbfceedfd598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f880a6d580f7e5bfb4b5c43c3a550c74a0853f99e6a609f05f3abb01c7f8fe12"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1237d87eb8b8c5f5bab1da9112f3343b460cdd45b256b8b4c7f6fcf54ec7b20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "995ef3b0a962a10b9d294904258f3beaf134f67feb542ec145b984c2f746386c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb67ffc6b722a94a68004c5ea9ed9a3d5940c44aeb3e434f724ba41d7c7c67a5"
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
