class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.10.8.tar.gz"
  sha256 "adda202530b8dd26b9d90e7ee18998d3c47890da06b102370c77f208fd83b64b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d698a74667be33df5e6ab813869e3156a8abb85b528af1daa4d306641951365a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "043da4153cad5b03b4cf0d0530254f7b5c408bf8bffd5887d73bd0f8533c5c9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c60e81994043384e76827a0b8e9d6c4a9e661ebfad2269fa20d5f697c190953"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d24f7808cd184b6e5097f26f30607b400413bb489baeeb02c597d9a5a602fba"
    sha256 cellar: :any_skip_relocation, ventura:       "09d84cf3e46f5bc0bad344b3308f4a275df9f41c819ad0abeded9b3cef10c0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5fea93b49a921c4eaddb8599e726cfc40c063e5356057771b6d26aa5665f74"
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
