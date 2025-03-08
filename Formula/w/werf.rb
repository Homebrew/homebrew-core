class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.31.1.tar.gz"
  sha256 "2c1c11e5899a824f8aa750edac646904ebe22f131a84f4b3719aa7f5c6ee3b65"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824963025ea5d67bbbf26151ffc25a56045ac79f93909c22e71a674e67f487d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad3dd7663215f397852fe0004526341b35d3802f4c9ffc4dfa3976aa5d724c7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d0f3c8ff405d6e397ff68456c4522ed138bbf1a56055a8878394d91eca49baa"
    sha256 cellar: :any_skip_relocation, sonoma:        "506c1534b6d23f1aa9237d3b8c5c9f20876f66dfc5c5d27ef1bb0d0462ffd916"
    sha256 cellar: :any_skip_relocation, ventura:       "6570a9f2c86813a490e6ea8ae8f49975d6216d9da270fbf82ccb9769f9ddec2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "598f3d7e7b1b461538596828e756008cb3abeac55339a9f00a5e3a9786851e5b"
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
