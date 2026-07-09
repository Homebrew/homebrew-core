class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.72.2.tar.gz"
  sha256 "c2093c71026583732a79143b6d4bcad8cd214c8d7ce973dbc6553645267aebfb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceaa6d3f756bc223e2700884eacb23b1c1f5500e02348422d9ab73a7343b2d54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ed7bfa86451befd67ee37761283cfa64745b9107a90957fa449b1c1bd0c2e19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dba315cadea2782e2d1cff1a44dd639e490df305d478e08912912071477d8105"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c71f017054315a3669d0006bd587416448498076aa6296a335da2579f04ba3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c955d9da74c7479292c71362637c4f0ca802204200c11192a55b892d659b87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80e213200e6e90839f99ceb17518fd3873a33350465b0d7e5c7f1fc47715de37"
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
