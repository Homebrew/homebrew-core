class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.67.1.tar.gz"
  sha256 "0455ea0de6f0b64377f6e8e5d58bfaecaccaf05a6804da34fd72dca05d74deb2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c7fcdb4eddbaf96cc6505f2eedab5fd59fc8b117c8d265913a89697abf971a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f36b148187c16fc721e706df336e32c9ba2cce55f52c8416b4d0b2e0dd48e75e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddda1732ab59eb21891c224ca2e85cfcd7a9fbaeeb7a032f36b5bdb1f62b472c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dbaea0e2e8ccc597a9cd8bec2a63f0a80b3a1fd72c759e26dd8a68ea1beef87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfe6619893f8a1902cf06c9111fee7a9a05b5a28a0f97def5acd36d2f13bb5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b072a64ff5691d2c1efd2dd25089ee27a2137f8f1690b04ec5048601767e736c"
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
