class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.67.1.tar.gz"
  sha256 "0455ea0de6f0b64377f6e8e5d58bfaecaccaf05a6804da34fd72dca05d74deb2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "989b3ec2ca685e2c0df702883ba102fe91583e6f6f4a8a63d67279b786d4da35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a9daa65493f46a585b68632796130e7c97777c4785cbb75537708c1aa7de72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37a587cabf01a38d8577eb41cb7669f2ff0b5d1a227a80300df488e7c9e22782"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b1cbb2fce3094f8de539168e976b335e29e9211005204486b9ded80e4c8244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1267a6b562de0c8a5271b41c336840020fadde029b970278d99cf673365d1d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576b900ddeefdfc8755f9c8cfdeca1df37fe143be09547a5385cd945f2c8859f"
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
