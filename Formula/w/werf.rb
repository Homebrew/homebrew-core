class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "4fa1ab803cd1c531c30e24a2cecd82b95e50ac3d879e8c03ae6650f2c45dc8e0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0609ee74bd3c0ffad9ceb237a30f79f66788d90159b95e1c36ed00870143ce70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e7b45ced2e0a3a0d1041d81c2fc04eccc060d34969861be5a93f3a3d69f5d90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32127582651fd7aa7188dd7b73db0c1e6e2d1be332d29c654984422ad8e136c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a9e2efaf704972b31290a0b8442ca6b40a84b28fd37c4d252f72de91be2cf5a"
    sha256 cellar: :any_skip_relocation, ventura:       "552b820dc3b548a15c9b62558175e3ef6335c74f2ce1d74ab6e4a015681ad5c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69914be1defb1d37f870feb15d6a2ace6d277f158a0669fb940445b373758e27"
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
