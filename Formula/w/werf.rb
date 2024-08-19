class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "8f3294402cc4dbafcf8026f34e1b7e8660a1a6f7442853794b46884135dfae30"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1352f1a87960f66b991624dca7fa65320be35f83a7dd3e0623524db6b27c9738"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b494e12f970def5f66abff7f2b105eaaaed96152190af44f6967796f97eea2fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93c48df656dcfca3d4affaeb2b53ab094cd251142bcd10e99a20fc30c80b3796"
    sha256 cellar: :any_skip_relocation, sonoma:         "f58aa9f899b7340fc074a571a9475aa113a197078fee0b0858766610d1798b51"
    sha256 cellar: :any_skip_relocation, ventura:        "88fd03d9aeadace63392795a6b7584d0f923ce54cf9e691962e3859f825ffdfe"
    sha256 cellar: :any_skip_relocation, monterey:       "1bd4eaae33f5d69e37fc6c6bae58c7e719ff264689b26ff2b0fead9c2d158e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0895d38719cccf703dd77ff7e1ccb841a2f048385bf412ef4ac10ef8f01c69d0"
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
