class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.300.tar.gz"
  sha256 "2cd8959f8e889d2de99b6671875c355681ee3d4c45a578e16d755619723aceeb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a15139f7c0df1b3fae05b24fd42c1c05bc69567fe61cd3a7738260adafbbb37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d8397e85d919648f531ad34c0543242a65e93cad6b836b7b542632b4db96048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d6c617124db4bc3667744493a5f1674b6ad474fde31f3a0e797b2340cb03fa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7808fef8bf5025bd2c91c214b0999a9c08d2e276117050e9c716759b1e129ecb"
    sha256 cellar: :any_skip_relocation, ventura:        "03d0c68b8562cfb4704dd34ff5f5cb39837e121f009b54e1d132ca818c67bc63"
    sha256 cellar: :any_skip_relocation, monterey:       "249fa5282b380abfd2f313304e9fd508478bcfbbeb492699071d5b93ef3da394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c7ea0f24d4f502e609f23fd121f6fe26852ee82e9a902a1fc3888c078072374"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
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
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
