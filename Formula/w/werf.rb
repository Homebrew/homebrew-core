class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.297.tar.gz"
  sha256 "762d1c526b06eaef84e014df6056cc4a1f4ceb4a07e73fef2309ec9d448654fe"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecca48eb5f9a5a6514c46757387bca02ecdaf6d284317dd4c081b7517f0d036b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1aefe488ddeb63b7b57ce062aa0291e4fe0c53090f7025c00b0eb4215c1bf9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f08beebe9c2bd343e6d9d4bf8e8ef9351fb40d777f7cfee38ac57b967ce45b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e25c78b4e45798aaf1bd972f89c3357c22977e5c4d82b2643c89f97195e07d8"
    sha256 cellar: :any_skip_relocation, ventura:        "8fcff0ac7951ba1264e62fad7f853baa69d88d1017695ccc9fd041329c8868de"
    sha256 cellar: :any_skip_relocation, monterey:       "89910d109375f28a35383c53d78c53c564004fb9bbc1f3ccdb35c3579f98fb86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c64b61fe3f28e0a07e3daacca2a62c00a322eea285a7787b4c7f3cfdee1e745e"
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
