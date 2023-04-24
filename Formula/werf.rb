class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.226.tar.gz"
  sha256 "170cd3faa7b54fe2a0a52a013c4b10b142f68af6c154d8b2d0eed65fda8cc932"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "304e7a93b081fd1b69b729366814a1c2ce4b89e67f1c1940f09b6ad159f09dd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1edbdd0ca0ba495d2e490bc3b75aad0b86591fb4386bdd27c2e35ced84a0b60a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71fb092f8ea4c44b71c4edc9d166409c608bd46a51ef4ec722a4adbeae980161"
    sha256 cellar: :any_skip_relocation, ventura:        "024762c2e18005517376103339831954a9170673cd6bd56a9c608e7e29f8b303"
    sha256 cellar: :any_skip_relocation, monterey:       "8f45738940be7a128f365ecb3b23688fcd2b3d8ad6d5fcb034886ad20cff3844"
    sha256 cellar: :any_skip_relocation, big_sur:        "20f66c10ffe6c61dbbf9565e95b9373895f7d602feee82790e269041eb72896f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ca9b5e5f660b98e6625f5143a7bb31722f9f46ddf3ba53c194e5341bfc13d3"
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
