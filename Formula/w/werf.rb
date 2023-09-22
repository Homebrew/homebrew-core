class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.258.tar.gz"
  sha256 "28945791467af6d493e4aae155abea2fd52949c5f1e285403c84b0ee78fae311"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f351afe876f03fd006d376722b8138a041fac939732d2ff11065ce095a889d02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73a57f7ad2015874bd2aed3919f6bae09c370a007b0e03938ee4a9ba18da9575"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08af8009f536714c9b4c19017df79b8fa90ac450fc2484bc86b2cc07de9fa792"
    sha256 cellar: :any_skip_relocation, ventura:        "0b47821c9d7e7b599489906be50c103c797bca74eb3f6b96cfb4b357a362587b"
    sha256 cellar: :any_skip_relocation, monterey:       "95688e70f3e98354173979a6685d0a662861aabe464681c053474955e539cfaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f8284c23c277d58b228432e377ec382247e03e2e8f0a5cffd55c4d5f6f4f424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ba7b42ff1bb4a9fadd452f0e4c6e6aec76d48529983f2868f9466b9b7f50f52"
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
