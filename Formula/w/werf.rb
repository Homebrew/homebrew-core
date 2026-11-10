class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.84.0.tar.gz"
  sha256 "adc9319ceb2ce9943fc859f1ec07b45a3b4a8cb4c4a7a9626fe1e15eeb2edb52"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a214a4d9359ae48eed1830b5d38ff1e8ed4e6314dcebbb30e08a1021893676b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e276a6b530a94928eb43ea02b73f33df89ded21c64b0872535a875cab6f4141c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31f74251960c96e19217c99b5bc3b005fe52d7ff29d9c251fd437e90d7600562"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a650fe391037301e8408f684095835ce2983ebb46b478c8ab55e809445b4507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "096bef65e2f1de25e056a938ef523f2019830479c3b56168af77be9435dea2ae"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[-X github.com/werf/werf/v2/pkg/werf.Version=#{version}]
    tags = %w[dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp]
    if OS.linux?
      ldflags += %w[-linkmode external -extldflags=-static]
      tags += %w[osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build]
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
