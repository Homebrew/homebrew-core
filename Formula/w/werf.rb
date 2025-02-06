class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "d6b2f53407838454444f7fad9939abecfcad3be48fa2bf5505e6f510f296ee1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af8ccabc88382a108c18b885c26bfe820368683ea9df46a22b2a77828df089b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a305f2f8912cd21d3f99b6425cd82f345a798e91eb4f9b2b6b5e8a33caa9fcd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc7dbb0c13c1b324ef8eb84aabd5a35bd7da8235688e18f4f4606826893c96bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a637f08cceefdc5ddfc6259e4d9fb6a53bf90cd3df710cc8b848ff665e367437"
    sha256 cellar: :any_skip_relocation, ventura:       "90e534b5c38a657aa38ceaed8c69366542c6eea7c8964c410f61a759faa1f443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e1f48833f4fea466cc48ab99d258a45e8bcf1d1f650f84432dcc290c8dd51c"
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
