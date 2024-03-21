class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.300.tar.gz"
  sha256 "2cd8959f8e889d2de99b6671875c355681ee3d4c45a578e16d755619723aceeb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "050643967eb26cf6faa867be41385809f92dc4333f0e0580fc690ada0d4b427b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4f83bbac8eac4f1bfb1f5a6dd1fba8748bccd59b8655709ef9466628497d606"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b697b90a1e2d4705a2e0c7f44da4247833cf6f6a86f2d5530e372799807ae666"
    sha256 cellar: :any_skip_relocation, sonoma:         "12cc01d9d4fab65d0b8c0d8eef867a61ce29e94da9dcab677a12e9bc963bab7d"
    sha256 cellar: :any_skip_relocation, ventura:        "4d90fb33c17ca11c4f4b72bc2c449b1a029a537003e6966b7b50952e2a8f8d6d"
    sha256 cellar: :any_skip_relocation, monterey:       "056f2f8c344fad09658e67fcefc0710bcc05d5d5a059369a53579bb52e546890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d0f8aefb5002bd850f20fdbfaf8a213d905ea12418afc40b790629679bbce7e"
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
