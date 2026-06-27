class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.71.0.tar.gz"
  sha256 "70d597565e4f7a42f3f16f1c548b7ba8242058fa95462a1ac85260bbba6ada0c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "846a490cb8e068b3a44949731e13ad41299a36dc292583297d0a37247a75e353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaeb059c529643ad6f89b0f8c5edb95e505ef4f80295107b9b35981f4ffeaf0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e441fa3249a8917126f33d3b7c15a0a9fb2ac86a34a36bce36c25f0487dd656"
    sha256 cellar: :any_skip_relocation, sonoma:        "69d9f1c37194a6b67a64a59beef8ab02fd18ff137b0737baeb90e815e66c0224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934618b1c3e4b785469dd1bacd14c3519d635fcbc02ff2451cd60c05ae6cf3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "132dd2c0af080d0a0f26c3967e85c8d6e7dec565da630e630d1e288ab54fb3b6"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}]
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
