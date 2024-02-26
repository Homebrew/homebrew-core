class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.294.tar.gz"
  sha256 "2584531ecefff7685bbcd1fbdcc1360c1834c992a17d01c8f2f0df7dd0f0a2ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d01899df7a24185f1f788d4bf38ddb03f8061156ae08ad31ed8ad0135749efb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84ee68b73d36e11a40ac4b7d310edc82b5aa408de34def761278ee9f318a275a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e18f12db2c37caa523a50b1fa942e6db261b1aa121be6e62c90e8a7f37a8d499"
    sha256 cellar: :any_skip_relocation, sonoma:         "2309c545e4b660a48e760f65fe12768ea840b81cdb471a5f516e4fb0520b0c2b"
    sha256 cellar: :any_skip_relocation, ventura:        "1e8b0d79dd84666221f7ccdbfcffac54a856645e47f36470f251908f57f9c9c9"
    sha256 cellar: :any_skip_relocation, monterey:       "ee7e226dce1d25474f75b4e95cc0f4c3bef8db39b6a5d3b55830015fd1ab4ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e996c7fb160124e86d9f8dff086292795c7f93c2c4f55955d0b861d84ff51130"
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
