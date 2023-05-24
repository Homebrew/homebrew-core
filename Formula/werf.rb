class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.236.tar.gz"
  sha256 "f78f0d50ce855e0c91d082b7ac96646d2ce6dafcd7961938ed35ebdd134502b4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70b3642623ba211291f3741d893c43835b84750c662d4947ab829e6a9086bd88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80bec9a8a5e5cf56036f60b9148fb2e2201326daf0fa8922e12ac48e77e0301a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d26c685aa85f00f839715228727041b69ff1959537205e0ff6275fb26a12618e"
    sha256 cellar: :any_skip_relocation, ventura:        "51e522c34e5d63647443e3a05285a6abe0bc988fa13a188c72bfc24090285500"
    sha256 cellar: :any_skip_relocation, monterey:       "4a2cfad6bf93efc3f2e72f4c3aa0efc98b26a4ab4b1bd176f20208c6bfbc2a8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c513e66554a0f67c5fcc008b6a279a0fb9b96069287c9f1adc801e4732d0237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf1783648e6a5d6b3d3162f912b1a507964682dc33c4b06235fa84c277916063"
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
