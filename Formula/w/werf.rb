class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.298.tar.gz"
  sha256 "237cb6aa64fde9d4b422c0c9f57c4dc0554f1db02675c719833d06a976533cdb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adf284f7d6ae9f96c188e6629a04fab6ad6cb09954290f3715ac78f14cdc44c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8922d17d29e9a54c52a536df3be122dcf52496c8293f5789544311e2da51472d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b6f3fbef3382701a02431398752d0c07052782db6ef647d5fbd9714721de3cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "775c576618d0815a1e3840e68b672237a483a0970c1b26f8c8d5e545aa3366e4"
    sha256 cellar: :any_skip_relocation, ventura:        "01040bcce209be070e7523e1d32be91eb813817a0f2754fe2eac147bd10b00ad"
    sha256 cellar: :any_skip_relocation, monterey:       "71b11da41f9d66db12f15dfe9cccee468a7a9a95d3cbb6c883d001f38872ca1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e3f7eafe4b40395669bba9cfda27145c3f496b93c6bf236852a7a355bafffa"
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
