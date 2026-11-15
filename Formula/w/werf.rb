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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d107485eac79274c824f380666a4f8ffad9937c7f92b164e895e461bd347e57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6d22bf9d281f7f13d0844135d932da33b1c13731e36ea2ab073cb014ca8591e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea0c027299f31a9a58684758e0f9bed82daa6d54ff4d46755efa1440f70f809f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "669c495017293998746a67d220ac02543812653da79fbca71546e46a8c914229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "388b15c51bb9367367c916dbe95753dfa8c19599c2d1df67bab37f34e5b10ca1"
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
