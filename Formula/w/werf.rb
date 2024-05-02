class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "5ae53bfaeee5f7614fa158a87366a55759cef4eb19a8008dd6ad107c5ec67e79"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c531d25676bbc9f480d8b3310a0a5996a65feadc37db1f743ca30715eb77a3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a4aa620af88a2a3557bf559c272640d003c6cfc53f8d4109fce41d5bb6ed4ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee145c49d9d975563cd11593d0f082dfedd120414a3a933397b088e1e71fc251"
    sha256 cellar: :any_skip_relocation, sonoma:         "a56f3216cfbfcf55a0b09ead4509af6523acf566e51bd274e72d49b2ec7fdeec"
    sha256 cellar: :any_skip_relocation, ventura:        "beed9ae5704b3f8594298c11afc6e110acadb3bcafc6417aa57b0121dc4be771"
    sha256 cellar: :any_skip_relocation, monterey:       "0c88faf86ffab24e45d96816cf0bb6922615ff95a61e4116d19bbaf1593350a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcc6cbf7b58305b802e133ab1210719392df879f1844bcac18c5fc6e05119661"
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
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
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
