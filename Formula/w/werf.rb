class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.6.6.tar.gz"
  sha256 "fc6297c78c8d3e4bfdfdce890052111fafdd651e34e3562b69eb15aeddeccc4d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54bc37ea2d20b4460e9ed74ac5ba58c2c3f28b762435fcf1a3c4093596992402"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83307aa44a6c6005b32e914956a5415ebdd845ac722814f76fff051f9231bc26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b363b3e9bf2900c91c615cb91384217321d6af15b1b40d93affa4495a4559af"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cc634afc21df9d9c67bca9b8c982fbad3d3d49ffcc10e3047b31e2bd3188e8e"
    sha256 cellar: :any_skip_relocation, ventura:        "33e10a8c145db59b7aa7701d47174f396ef045908081e79c6836e433dc33c12b"
    sha256 cellar: :any_skip_relocation, monterey:       "557be319d997da682f3e6f2196848242bba28a9fec0a66ca5b33e2a7bdd6b9f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d56b76abbc7cc827e16d4f605bd3f94a961564b31728ea2eda290df0444894f8"
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
