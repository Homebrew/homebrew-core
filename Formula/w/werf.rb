class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.84.1.tar.gz"
  sha256 "e717da648c16275d9416ff6ffc10e370ab65d7c792983b7d18b43aa91e25560d"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "070d417be7f770314dd58e2e603029edb10872d22883beae68d22e9f554cfd00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b5a068bf6553931236010aee6ac36fc732bbaf6ced6fba94d20f2e2825e061b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "263fa111efe9660fd2fb8924c8c8d88740de1067c2f142c6aff8d9d54e0ed3c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d33ed015fdaa77cc224c4c39bb19c7fbc19c86c7a4ab193ec7c533886abea61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de97cc0547c4f75b00a5b2415d0a60a26ebe05ae8171111a96c96160cb84ef58"
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
