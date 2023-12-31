class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.277.tar.gz"
  sha256 "86c33eaec9bb724686e4e9c641ef83b8922124eccef27d9d05df99245004bd92"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94bcd8cf53a0f09bd42d8ea1dbd75cddd3d3600cbfcb1e4a91ed25f0d482b6bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e0369e23febfcad72bc0f8d3d4306544619f1c84f52890ca89bfcdd476ce8d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13669bdd4d8493bfcedd82358d55211c64a0d028a0ee5faaef20c58e6b7d6a54"
    sha256 cellar: :any_skip_relocation, sonoma:         "36505414d2df128a2ceaca7729bf3d70938079195226eecae2a059b831a5b4b3"
    sha256 cellar: :any_skip_relocation, ventura:        "58f664aa777d1d5a5731e7a4217aff183be5f33302a19da568e8c77a91cea8e4"
    sha256 cellar: :any_skip_relocation, monterey:       "d37576777ad604c77b9022cc770d9654149cd16e5f4722220cc450bf95357aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f5a356d205b44d395da405cbd817c33d83c9d0baeb7a090c1df9f8828324a0a"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

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
