class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v3.12.2.tar.gz"
  sha256 "2d8e034c39dba2a20285a2396d2d6c6f5cd12ca089a98df479268bbfb9bb5542"
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
    manifest_sha256 "0a5c63053d985686d2ae5c94862f99f2ed0d930316f500b1c71b80e9c03b8eaa"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db70cbb9d4294723869a7e86e5bbd1dd3194daea8ed7c2c574025f78305adc19"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "567a9846a0a2c331ad878bd6960bc4ba76b95f8e39c8b6751b918ba9efd950e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f11271284e628275117c9479cf7daa8423a2f9284323e2161ab083b7f30cfba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4fea48d046819c5966e1bd8243bdfe26f0fcaee95f3670810a77438bf47648f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e85edd48dd42d1a3c864bb4f4305bc721eaa02974b880b1ff47fd6d2b06bb779"
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

    ldflags = %W[-X github.com/werf/werf/v3/pkg/werf.Version=#{version}]
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
