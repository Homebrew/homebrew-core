class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.190.tar.gz"
  sha256 "31a46c88ac005b50b8f1ae8ab722aa36bc020f81d3e698fe5c9268c62a603950"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34ed3a7647f00d033d5009957de645a4a598dad6f6ada971eb4373ad481153ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d01f7f809a1f828aed5a45a9a5e12643dce038c639ddda13a2b0de20df7d6271"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5d9a9688cc04d80b6ed483d3968773b4d6fa261b0f1ea96f26ba113275d1e3d"
    sha256 cellar: :any_skip_relocation, monterey:       "d100436632297b6481d11063698c466d1b66aa1d111d25a019769a451bef2ea9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a480b70f989af0b753487455b456a55fee34b1e104f1c2f160e12b109303e17"
    sha256 cellar: :any_skip_relocation, catalina:       "36e8b04c0a7acd4cfbb4e17c9e4cd012a8c65f5bef4beefce4f24b95c394caa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f0da3dea2f650ab693eae88ebf072c6d96e7b1006e93a765148037dfc2652c2"
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
