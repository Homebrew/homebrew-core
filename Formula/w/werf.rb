class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.76.0.tar.gz"
  sha256 "414cd8dde95536f0a96f783f7968c46d5ecb4e4bfee0157fefa7cfb449879ce0"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "203d72d996308e1b20cd9c7788629c9c3518935194addafeac47f59279dd3192"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bd738fd6714e32c975bf8e583dbf4060fd0454718304e85db4196f764acf3a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "290d50890e666399784d3367c9334f1074f5193c9b3dcf4dfd61e053488aae8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "dbd5f2080620ed4c2ee42f20ecbbf4144551961f3b5c7a4f44dbab58906c11f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c136b67ec6762fba3da118616e560af7b1ac2a0386cac6e35a25f4cad11a2330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4107bf031b48791739bf748a928569127c18089b3a8b4d6be96905deae3bc0f6"
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
