class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.57.2.tar.gz"
  sha256 "12285214b47c87d1837009310dc4baec62cf20d3289aebffea42db58da54d13c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d33496e3b3e657afe33c6ffbfe4c5545cec8d216ac3e1e590729c0d2387e28b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdc73df385e3b28208306537b8358725e68b150f268d128efa1492af9c4f1f3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75090bfeda04d18f734914b67738387fd3dba4a7040b7840aa67baf6a80d7243"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bfc6e01c3a023127510520eb5904904daae8b19c3b93237a811573ebc22454b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a870fe4584de27cedbc710cd5c093196e5d221b07be506d6a884eb4209fd7b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec0d25a21168a455eb2b309e5378238f1f497c90bba4301fe02df4fde9747e0c"
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
