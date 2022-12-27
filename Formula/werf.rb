class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.194.tar.gz"
  sha256 "4b6e4eadfaf20d5dfe798a433b0d54b1a69ff1bf99e97ed6aaf23949c0492d5e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50f92c91bde804ec6c7e58b010da95edd17616ca7007a3af1664d6f19a67fa75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d02e27d1fcc008a606600382d63e568e5f841827bcecd88b654c5302baf9fef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da3c95e76b95c5b4a852342cf282d51598e844d2d57ca6f3d5f60f19e7859d1b"
    sha256 cellar: :any_skip_relocation, ventura:        "78344a61527287232a3a624b0dc5751f574cd0649cb51d1e6e56e6d4a4403645"
    sha256 cellar: :any_skip_relocation, monterey:       "afe2e94938059ebc8bef0c913af519c80643faa9646814437dc3e5c8b7aa44aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce52db20dcebfa9b52195488f2e3fa18cd97661815d906b8975561beae82d911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c54b9230f2beaedc4572a3a8f95d1dfbb9c677491d7c0887f6a427c181abbe"
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
