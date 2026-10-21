class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.81.4.tar.gz"
  sha256 "fc515915e3a5134b2ccf4d651d38b3d3553abafd894ea3d15f952085b6980f53"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b0db777c15de3a1feff863b573c4f16736550f3b24e1701157d50e36398f14e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9937fcc746f94edd0bf5438841889bdeaca359f4626ae016ad7fc94a1643eff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "472c5349b758ae0684724ed8bdc46965403cdb119b2255d9b07fef729399136f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f42451245bf4301edf01ad6fd4135c6ad2995af8bf041d65f748f697a8cd1a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "57a469b3ace253b5fae5dea3e285f863f0159ffcf5f9f782f93edfa83e4f9c07"
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
