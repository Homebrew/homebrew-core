class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.68.0.tar.gz"
  sha256 "2a110299dab96ef60f13972276fc60e02c6637ed1c2a6dc6b0287afb66236d1a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47a99fa79110497af4425d53511e44d4f3a389133cdb10d44013c86075577c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06e8f85feea66d75c94a862b6069b71cb0c537cfad6e6ab9ae8b3df0d6ab61cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c329ba89ac5c0a06dfda2a46fe28508f1b87251b5909e06dbd1cb8594ea5e8ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ed0ae87d3cb6e37bc00cd833681112605a374ab1807c1048b85eee0b424c1ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46068edf671d6dc47524402bc653a2ec5c31f525d3018354ec16139bf36f4996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "987361fca5052b1bbcce0f754ecc172c13ef2696c6ee5e1e00a4a46dd44e66ae"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

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
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", shell_parameter_format: :cobra)
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
      - image: result
      - image: vote
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output,
                 shell_output("#{bin}/werf config graph").lines.sort.join

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
