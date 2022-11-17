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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fae118edf0f0f26c519bbff123cc9e40e8d922b3da6218fbddb3ee1d18ac3ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b798fd502e59e290d3c6ee28ee1ecb8fdc034ae424da7466a095a135551559d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78cc9c588d6cee237bea1a5e658732d4d259d1412bc2a5dfe03f51d83b616ab6"
    sha256 cellar: :any_skip_relocation, monterey:       "0b7c3f58b5b55b447e387012ca3af18b4ae9b9e1383e248e8aeecb0e87e88703"
    sha256 cellar: :any_skip_relocation, big_sur:        "c512776af744d3a0a60ade6d3119e2ee2db6a212053dfba35431f5f7df50dee7"
    sha256 cellar: :any_skip_relocation, catalina:       "6a7c9e39e8ec0bab64e581bce537f310f05a387e262e4c98962f90ef12aa4f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "309ceae50e25b8b9f0372506119eb33f363e6084a48415ab323cedfd9d885d1f"
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
