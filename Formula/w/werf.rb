class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.47.5.tar.gz"
  sha256 "a27ae54ac6db63b724504c25f90d050dfa1c093d9a4657e8a6733076e1c481ff"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c77c9d1d0b3dd7ee0d07dee0c652aa334d63ac728de9a9caecd2fa108e0ca5cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68bd9b8a3e0682856e4792dd13ca88b873497a170d36088fe7ec719c9c904998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b53d5555873734389478d611b597a084583c568a60bfe9498260d436c8409cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d440eddbbab1ec95736dbed17e19c9be6fb5d45420d71920ac92d48aed94cc38"
    sha256 cellar: :any_skip_relocation, sonoma:        "e22fafe3097e4aacbb4947687d2ea1e6c310065f3f4969f4e636f18bcdc777de"
    sha256 cellar: :any_skip_relocation, ventura:       "70801a457ca1174ab4312f64ad0c1073c7caaded46b0c0030a713e87f861a523"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da232b33a99f37de9567c6564ad462ddd8efe22e0374f4fcc55eb803fff52a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a88b2e54d00866cfc45ee8877d53dfb6e02a3cabb73ab893220250fb57eed5"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
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

    generate_completions_from_executable(bin/"werf", "completion")
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
