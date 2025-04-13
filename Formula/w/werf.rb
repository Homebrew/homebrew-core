class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.35.1.tar.gz"
  sha256 "784122100ac258c14be923bdb7436a37efa2b9925d6e53c26791432db46f9d41"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f99e25cd96dc11184c7c4b618f7c5cee09bdc67fa73076536cfe593fd3d2416"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "072f93b5fb1e74626c66a07c13894a98e440369f78031ca75bbcf150e209bff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e60f23d53a735d6ef77269009e0f1cb8acaec367cefaee4769b298ce476999a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd96e6f4eff2324e1deadd1da21249fe816f94f7680f4f7fba6f87857d2b8c2"
    sha256 cellar: :any_skip_relocation, ventura:       "d88a6d45e2abf425970150088d81ee5fa74af94277b8fa8fe05f886e6d9007a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e525a94d1d69fd58f6a8b3eb92a4e68d3f12a65ec2770cc6fde9ec0e9a3c3b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14818aee18d5645dbd256efc863fa5fc87bdb706a18df6ffe3f623ca201d78e8"
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
